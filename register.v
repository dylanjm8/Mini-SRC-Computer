`timescale 1ns/10ps

module register#(parameter qInitial = 0)(
	input wire clr,
	input wire clk, 
	input wire enable,
	input wire [31:0] d,
	output reg [31:0] q
);
		
 initial q = qInitial;
always@(negedge clk) 
	begin
		if (clr) begin
			q[31:0] = qInitial;
		end
			else if(enable) begin
			q[31:0] = d[31:0];
		end 
	end
endmodule