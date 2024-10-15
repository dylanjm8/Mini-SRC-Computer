module Datapath(

	input wire PCout, Zlowout, Zhighout, MDRout, R2out, R3out, // add any other signals to see in your simulation
	input wire MARin, Zin, PCin, MDRin, IRin, Yin, LOin, HIin,
	input wire IncPC, Read, 
	input wire [4:0] opcode, 
	input wire R1in, R2in, R3in,
	input wire clock,
	input wire [31:0] Mdatain,
	input wire clear,
	input wire GRA, GRB, GRC, Rin, Rout, BAout, Write, Cout, InportOut,
	input wire [31:0] InportIn,
	input wire OutportIn // comment

	
);	

	//Phase 2 - select logic
	wire [31:0]C_Sign_Extended;
	wire [15:0] Regin_IR;
	wire [15:0] Regout_IR; 
	wire [3:0] decode_in;
	
	// Phase 2 - RAM
	
	wire [31:0]RAM_data_out; 
	
	// input and output registers
	wire [31:0] InportOutput, OutportOut;
	// wire OutportIn; 
	wire [31:0] BusMuxInR0_to_AND;
	
	// wire Write; 
	
	//Register in out signals
	wire R0out, R1out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out;
	wire R0in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in;

	//MAR signals
	// input wire MARin, 
	wire [31:0]MemoryIn_MAR;
	
	//MDR signals
	//input wire MDRout, MDRin, memRead,
	//input wire [31:0]mDataIn,
	wire [31:0]mDataOut;
	wire [31:0]MDR_mux_out;
	
	
	//PC signals
	//input wire PCout,
	
	//Z Register signals
	//input Zin, Zhighout, Zlowout,
	
	//input HIin, LOin, HIout, LOout,
	
	//Y register signals
	//input Yin,
	
	//IR signals
	//input IRin
	
	reg [15:0] enableReg; 
	reg [15:0] RoutIR;
// register fill phase 2

		always@(*)begin		
			if (Regin_IR)enableReg<=Regin_IR; 
			else enableReg<=16'd0;
			if (Regout_IR)RoutIR<=Regout_IR; 
			else RoutIR<=16'b0;	
		end 
	
	
wire [31:0] BusMuxInRZ;
wire [31:0] BusMuxOut;
wire [31:0] BusMuxIn_R0, BusMuxIn_R1, BusMuxIn_R2, BusMuxIn_R3, BusMuxIn_R4, BusMuxIn_R5, BusMuxIn_R6, BusMuxIn_R7, BusMuxIn_R8, BusMuxIn_R9, BusMuxIn_R10, BusMuxIn_R11, BusMuxIn_R12, BusMuxIn_R13, BusMuxIn_R14, BusMuxIn_R15; 
wire [31:0] BusMuxIn_HI, BusMuxIn_LO, BusMuxIn_zHigh, BusMuxIn_zLow, BusMuxIn_PC, BusMuxIn_MDR, BusMuxIn_In_Port, C_sign_extended, AluIn_Y;
wire [31:0] ControlIn_IR;


wire [31:0] Zregin;
wire [63:0] AluOut;

//General purpose registers
register R0(clear, clock, enableReg[0], BusMuxOut, BusMuxInR0_to_AND);
register R1(clear, clock, enableReg[1], BusMuxOut, BusMuxIn_R1); 
register R2(clear, clock, enableReg[2], BusMuxOut, BusMuxIn_R2); 
register R3(clear, clock, 1'b1, 32'h00000011, BusMuxIn_R3 ); //comment 
register R4(clear, clock, enableReg[4], BusMuxOut, BusMuxIn_R4);
register R5(clear, clock, enableReg[5], BusMuxOut, BusMuxIn_R5);
register R6(clear, clock, enableReg[6], BusMuxOut, BusMuxIn_R6);
register R7(clear, clock, enableReg[7], BusMuxOut, BusMuxIn_R7);
register R8(clear, clock, enableReg[8], BusMuxOut, BusMuxIn_R8);
register R9(clear, clock, enableReg[9], BusMuxOut, BusMuxIn_R9);
register R10(clear, clock, enableReg[10], BusMuxOut, BusMuxIn_R10);
register R11(clear, clock, enableReg[11], BusMuxOut, BusMuxIn_R11);
register R12(clear, clock, enableReg[12], BusMuxOut, BusMuxIn_R12);
register R13(clear, clock, enableReg[13], BusMuxOut, BusMuxIn_R13);
register R14(clear, clock, enableReg[14], BusMuxOut, BusMuxIn_R14);
register R15(clear, clock, enableReg[15], BusMuxOut, BusMuxIn_R15);
// phase 2 edits to r0 - taking r0 output compared through and with !BA
assign BusMuxIn_R0 = {32{!BAout}} & BusMuxInR0_to_AND;


//Special registers
PC PC(clock, IncPC, PCin, BusMuxOut, BusMuxIn_PC);
register IR(clear, clock, IRin, BusMuxOut, ControlIn_IR);
register Y(clear, clock, Yin, BusMuxOut, AluIn_Y);
register ZHigh(clear, clock, Zin, AluOut[63:32], BusMuxIn_zHigh);
register ZLow(clear, clock, Zin, AluOut[31:0], BusMuxIn_zLow);
register MAR(clear, clock, MARin, BusMuxOut, MemoryIn_MAR);
register HI(clear, clock, HIin, BusMuxIn_zHigh, BusMuxIn_HI);
register LO(clear, clock, LOin, BusMuxIn_zLow, BusMuxIn_LO);

// mdr (register + mux)
MDR MDMux(BusMuxOut, RAM_data_out[31:0], Read, MDR_mux_out[31:0]);			

register MDRreg(clear, clock, MDRin, MDR_mux_out[31:0], BusMuxIn_MDR[31:0]);

// Encode logic 
select_encode_logic logicff(ControlIn_IR, GRA, GRB, GRC, Rin, Rout, BAout, opcode, C_Sign_Extended, Regin_IR, Regout_IR, decode_in);

// Con ff logic 
conff logicdq(ControlIn_IR[20:19], BusMuxOut[31:0], Conin, Conout);

// RAM 
RAM RAM(Write, clock, BusMuxIn_MDR[31:0], MemoryIn_MAR[8:0], RAM_data_out[31:0]); //removing read for now

// Input and output registers
// (no enable to input port)

register input_port(clear, clock, 1'd1, InportIn[31:0], BusMuxIn_In_Port);
register output_port(clear, clock, OutportIn, BusMuxOut, OutportOut);
//ALU
ALU alu(AluIn_Y, BusMuxOut, BusMuxOut, opcode, operation, AluOut[63:0]);//operation - opcode from tb(mdata) might be wrong 31:27 is 00101

////Bus
//Bus bus(BusMuxIn_R0, BusMuxIn_R1, BusMuxIn_R2, BusMuxIn_R3, BusMuxIn_R4, BusMuxIn_R5, BusMuxIn_R6, 
//BusMuxIn_R7, BusMuxIn_R8, BusMuxIn_R9, BusMuxIn_R10, BusMuxIn_R11, BusMuxIn_R12, BusMuxIn_R13, BusMuxIn_R14, 
//BusMuxIn_R15, BusMuxIn_HI, BusMuxIn_LO, BusMuxIn_zHigh, BusMuxIn_zLow, BusMuxIn_PC, BusMuxIn_MDR, 
//BusMuxIn_In_Port, C_Sign_Extended, R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, 
//R10out, R11out, R12out, R13out, R14out, R15out, HIout, LOout, Zhighout, Zlowout, PCout, MDRout, InportOut, 
//Cout, BusMuxOut);

//Bus
Bus bus(BusMuxIn_R0, BusMuxIn_R1, BusMuxIn_R2, BusMuxIn_R3, BusMuxIn_R4, BusMuxIn_R5, BusMuxIn_R6, 
BusMuxIn_R7, BusMuxIn_R8, BusMuxIn_R9, BusMuxIn_R10, BusMuxIn_R11, BusMuxIn_R12, BusMuxIn_R13, BusMuxIn_R14, 
BusMuxIn_R15, BusMuxIn_HI, BusMuxIn_LO, BusMuxIn_zHigh, BusMuxIn_zLow, BusMuxIn_PC, BusMuxIn_MDR, 
BusMuxIn_In_Port, C_Sign_Extended, RoutIR[0],  RoutIR[1],  RoutIR[2],  RoutIR[3],  RoutIR[4],  RoutIR[5],  RoutIR[6],  RoutIR[7],  RoutIR[8],  RoutIR[9], 
 RoutIR[10],  RoutIR[11],  RoutIR[12],  RoutIR[13],  RoutIR[14],  RoutIR[15], HIout, LOout, Zhighout, Zlowout, PCout, MDRout, InportOut, 
Cout, BusMuxOut);

endmodule