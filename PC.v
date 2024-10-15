`timescale 1ns / 1ps

module PC #(parameter q_init = 0)(
	
	input clk, PCinc, enable,
	input [31:0] inPC,
	output reg[31:0] PCn
	
	);

	
initial PCn = q_init;

always @ (negedge clk)
	begin
		if(PCinc == 1 && enable == 1)
			PCn <= PCn + 4;
		else if (enable == 1)
			PCn <= inPC;
	end
				
endmodule