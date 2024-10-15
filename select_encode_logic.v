`timescale 1ns/10ps

module select_encode_logic(input [31:0] instruction,
			   input Gra,
			   input Grb,
			   input Grc,
			   input Rin,
			   input Rout, 
			   input BAout,
			   output [4:0] opcode, 
			   output [31:0] C_sign_extended,
			   output [15:0] RegIn, 
			   output [15:0] RegOut, 
			   output wire [3:0] decoderInput);
				
	wire [15:0] decoderOutput;
	
	assign decoderInput = (instruction[26:23]&{4{Gra}}) | (instruction[22:19]&{4{Grb}}) | (instruction[18:15]&{4{Grc}});
	decoder4to16 decode(decoderInput, decoderOutput);
	
	// assign opcode = instruction[31:27];
	
	// extend 18th bit to remainder of instruction
	assign C_sign_extended = {{13{instruction[18]}},instruction[18:0]};
	assign RegIn = {16{Rin}} & decoderOutput;
	assign RegOut = ({16{Rout}} | {16{BAout}}) & decoderOutput;
endmodule