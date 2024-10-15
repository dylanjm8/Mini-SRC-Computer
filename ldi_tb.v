		`timescale 1ns/10ps

		module ldi_tb;
		
			reg PCout,Zlowout, Zhighout, MDRout, R2out, R3out; // add any other signals to see in your simulation
			reg MARin, Zin, PCin, MDRin, IRin, Yin, LOin, HIin;
			reg IncPC, Read;
			reg [4:0] opcode; 
			reg R1in, R2in, R3in;
			reg Clock;
			reg [31:0] Mdatain;
			reg clear;
			reg GRA, GRB, GRC;
			reg Rin, Rout; 
			reg BAout, Write, Cout;
			reg InportOut;
			reg [31:0] InportIn;

			parameter Default = 4'b0000, T0 = 4'b0111, T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100, T6 = 4'b1101, T7 = 4'b1110;
			reg [3:0] Present_state = Default;

Datapath DUT(PCout, Zlowout, Zhighout, MDRout, R2out, R3out, MARin, Zin, PCin, MDRin, IRin, Yin, LOin, HIin, IncPC, Read, opcode, R1in,
R2in, R3in, Clock, Mdatain, clear, GRA, GRB, GRC, Rin, Rout, BAout, Write, Cout, InportOut, InportIn);
		

initial
	begin
		Clock = 0;
		clear = 0;
end

always
		#10 Clock <= ~Clock;

always @(posedge Clock) 
	begin
		case (Present_state)
			Default			:	#20 Present_state = T0;
			T0					:	#20 Present_state = T1;
			T1					:	#20 Present_state = T2;
			T2					:	#20 Present_state = T3;
			T3					:	#20 Present_state = T4;
			T4					:	#20 Present_state = T5;
			T5					:	#20 Present_state = T6;
			T6					:	#20 Present_state = T7;
		endcase
end

always @(Present_state) 
	begin
	#10 
		case (Present_state) //assert the required signals in each clockcycle
			Default: begin // initialize the signals
				PCout <= 0; Zlowout <= 0; MDRout <= 0; 
				MARin <= 0; Zin <= 0; // CON_enable<=0; 
				// using inport in as immediate load location
				InportIn<=32'h00100038; 
				InportOut <= 0;
				R2out <= 0; 
				PCin <=0; MDRin <= 0; IRin <= 0; 
				Yin <= 0;
				IncPC <= 0; Write<=0;
				Mdatain <= 32'h00000000; GRA<=0; GRB<=0; GRC<=0;
				BAout<=0; Cout<=0;
				opcode <= 5'b00000;
				// InPortout<=0; 
				Zhighout<=0; // LOout<=0; HIout<=0; 
				HIin<=0; LOin<=0;
				Rout<=0;Rin<=0;Read<=0;
				// R0_R15_enable<= 16'd0; R0_R15_out<=16'd0;
			end	
						
			//Case 1: ld R2, 0x95 Instruction h01000095
			//Case 2: ld R0, 0x38(R2) Instruction h08100038. 00100038

T0: begin 
	 InportOut <= 1;
end

T1: begin //Loads MDR from RAM output
		InportOut <= 0;
		MDRin <= 1; Read <= 1; MARin <=1; Zin <= 1; Zlowout <= 1; //PCout <= 1;  // start here use MAR to write address? RUN THE 8 bits thru mar
end

T2: begin
	MDRin <= 0; Zlowout <= 0; Read <= 0; PCout <= 0; MARin <= 0; Zin <= 0;
	MDRout <= 1; IRin <= 1;	PCin <= 1; IncPC <=1;	
end

T3: begin
	MDRout <= 0; IRin <= 0;	PCin <= 0; IncPC <=0;		
	GRB<=1; BAout<=1;
end

T4: begin
	GRB<=0; BAout<=0; 
	Cout<=1; 
end

T5: begin
	Cout<=0; 
	Zlowout <= 1; MARin<=1; Yin<=1; Zin <= 1; 
end

T6: begin
	Zlowout <= 0; MARin<=0; Yin<=0; Zin <= 0;  
	Read	 <= 1; MDRin <= 1;  

end
T7: begin
	Read <= 0; MDRin <= 0; MARin <= 0;
	MDRout <= 1; GRA <= 1; Rin <= 1;
	 #20 MDRout <= 0; GRA <= 0; Rin <= 0;
end

endcase

end

endmodule
