module Bus (
	//Mux
	input [31:0]BusMuxIn_R0, input [31:0]BusMuxIn_R1, input [31:0]BusMuxIn_R2, input [31:0]BusMuxIn_R3, input [31:0]BusMuxIn_R4, input [31:0]BusMuxIn_R5, input [31:0]BusMuxIn_R6, input [31:0]BusMuxIn_R7, input [31:0]BusMuxIn_R8, input [31:0]BusMuxIn_R9, input [31:0]BusMuxIn_R10, input [31:0]BusMuxIn_R11, input [31:0]BusMuxIn_R12, input [31:0]BusMuxIn_R13, input [31:0]BusMuxIn_R14, input [31:0]BusMuxIn_R15,
	input [31:0]BusMuxIn_HI, input [31:0]BusMuxIn_LO, input [31:0]BusMuxIn_zHigh, input [31:0]BusMuxIn_zLow, input [31:0]BusMuxIn_PC, input [31:0]BusMuxIn_MDR, input [31:0]BusMuxIn_In_Port, input [31:0]C_sign_extended,
	
	
	//Encoder
	//  based on figure 3
	//32-to-5 Encoder inputs
	input R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
	input HIout, LOout, Zhighout, Zlowout, PCout, MDRout, InportOut, Cout,

	//32:1 Mutiplexer BusMux outputs
	output wire [31:0]BusOut
);

reg [31:0]q;

always @ (*) begin
	//checks conditions of control signals (R0out, R1out, etc.) and selects corresponding input (BusMuxIn_R0, BusMuxIn_R1, etc.)
	//if none of the control signals are true the value of 'q' stays the same
	if(R0out) q = BusMuxIn_R0;
	if(R1out) q = BusMuxIn_R1;
	if(R2out) q = BusMuxIn_R2;
	if(R3out) q = BusMuxIn_R3;
	if(R4out) q = BusMuxIn_R4;
	if(R5out) q = BusMuxIn_R5;
	if(R6out) q = BusMuxIn_R6;
	if(R7out) q = BusMuxIn_R7;
	if(R8out) q = BusMuxIn_R8;
	if(R9out) q = BusMuxIn_R9;
	if(R10out) q = BusMuxIn_R10;
	if(R11out) q = BusMuxIn_R11;
	if(R12out) q = BusMuxIn_R12;
	if(R13out) q = BusMuxIn_R13;
	if(R14out) q = BusMuxIn_R14;
	if(R15out) q = BusMuxIn_R15;

	if(HIout) q = BusMuxIn_HI;
	if(LOout) q = BusMuxIn_LO;
	if(Zhighout) q = BusMuxIn_zHigh;
	if(Zlowout) q = BusMuxIn_zLow;
	if(PCout) q = BusMuxIn_PC;
	if(MDRout) q = BusMuxIn_MDR;
	if(InportOut) q = BusMuxIn_In_Port;
	if(Cout) q = C_sign_extended;
	
end
assign BusOut = q;
endmodule