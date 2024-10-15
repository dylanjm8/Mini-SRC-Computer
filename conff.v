`timescale 1ns/10ps

module conff(input [1:0] IR_bits, input signed [31:0] bus, input CON_input, output CON_output);
	wire [3:0] decoderOutput;
	wire equal;
	wire notEqual;
	wire positive;
	wire negative;
	wire branchFlag;
	wire CON_not;
	
	// determining which flags to declare based on bus
	assign equal 		= (bus == 32'd0) ? 1'b1 : 1'b0;
	assign notEqual		= (bus != 32'd0) ? 1'b1 : 1'b0;
	assign positive		= (bus[31] == 0) ? 1'b1 : 1'b0;
	assign negative 	= (bus[31] == 1) ? 1'b1 : 1'b0;
	
	decoder_2_to_4	dec(IR_bits, decoderOutput); // take the ir bits and extend to 4 bit length to use in flag
	
	//create flags indicating the condition to branch the input value using the schematic given
	assign branchFlag = (decoderOutput[0]&equal|decoderOutput[1]&notEqual|decoderOutput[2]&positive|decoderOutput[3]&negative);
	
	// Pass the values to a seperate file to set variables Q and !Q	
	assign_logic ff_logic(CON_input, branchFlag, CON_output, CON_not);
endmodule