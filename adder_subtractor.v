module adder_subtractor(input wire [31:0]A, input wire [31:0] B, input wire [1:0]mode, output [31:0] Result);

reg [31:0] Sum;
reg [32:0] LocalCarry;

wire [31:0] Bmod;

assign Bmod = {32{mode}} ^ B;

integer i;

always@(A or B)
	begin
        LocalCarry <= 33'd0;
        LocalCarry[0] <= mode;
        
		for(i = 0; i < 32; i = i + 1)
		begin
            Sum[i] = A[i]^Bmod[i]^LocalCarry[i];
            LocalCarry[i+1] = (A[i]&Bmod[i])|(LocalCarry[i]&(A[i]|Bmod[i]));
		end
end
assign Result = Sum;
endmodule

