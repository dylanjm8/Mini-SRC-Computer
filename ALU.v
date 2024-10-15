module ALU #(parameter qInitial = 0)(
	 input wire[31:0] Y, //r3
    input wire[31:0] B, //r2
	 input wire [31:0] A, 
    input [4:0] opcode,
	 input operation,
    output wire [63:0] Result
);


reg [63:0] q;
wire [63:0] op_result;
wire [31:0] add_output;
wire [31:0] sub_output;
wire [31:0] neg_output;
wire [63:0] mul_output;
wire [63:0] div_output;
initial q[63:0] = qInitial;

// Instantiate operation modules
adder_subtractor add_inst(Y, B, 2'b0, add_output);
adder_subtractor sub_inst(Y, B, 2'b1, sub_output);
adder_subtractor neg_inst(32'd0, A, 2'b1, neg_output);
multiplier mul_inst(Y, B, mul_output);
 // divider div_inst(Y, B, div_output);
always @ (*)
begin // change all opcodes
    case (opcode)
      5'b00000: //ADD - load
			q <= add_output;
		5'b00001: //SUB
			q <= sub_output;
		5'b00010: //MUL
			//q <= Y * B;
			q <= mul_output;
		//5'b00011: //DIV
			//q <= div_output;
		5'b00100: //SHR
			q = A >> B;
		5'b00101: //SHRA
			q = A >>> B;
		5'b00110: //SHL
			q = A << B;
		5'b00111: //ROR
			q = A >> B[4:0] | A << (32 - B[4:0]);
		5'b01000: //ROL
			q = A << B[4:0] | A >> (32 - B[4:0]);
		5'b01010: //AND
			q <= Y & B; // using y since it is r2
		5'b01011: //OR
			q = Y | B;
		5'b01100: //NEG
			q <= neg_output;
		5'b01101: //NOT
			q = ~Y;
		default: //base case=0
			q = 0;

    endcase
end
assign Result[63:0] = q[63:0];
endmodule