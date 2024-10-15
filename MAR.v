`timescale 1ns / 1ps

module MAR(
	input wire clk, 
	input wire rst,
	input wire MARin,
	input wire [31:0] bus_contents,
	output [8:0] q
);
		
	wire [31:0] MAR_data_out;
	
	register MAR(clk, rst, MARin, bus_contents, MAR_data_out);
	
	assign q = MAR_data_out[8:0];
	
endmodule