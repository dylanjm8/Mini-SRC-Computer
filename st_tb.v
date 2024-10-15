		`timescale 1ns/10ps

		module st_tb;
		
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

			parameter Default = 4'b0000, T0 = 4'b0001, T1 = 4'b0010, T2 = 4'b0011, T3 = 4'b0100, T4 = 4'b0101, T5 = 4'b0110, T6 = 4'b0111, T7 = 4'b1000, T8 = 4'b1001, T9 = 4'b1010, T10 = 4'b1011, T11 = 4'b1100, T12 = 4'b1101, T13 = 4'b1110, T14 = 4'b1111;
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
			T7					:	#20 Present_state = T8;
			T8					:	#20 Present_state = T9;
			T9					:	#20 Present_state = T10;
			T10					:	#20 Present_state = T11;
			T11					:	#20 Present_state = T12;
			T12					:	#20 Present_state = T13;
			T13					:	#20 Present_state = T14;
		endcase
end

always @(Present_state) 
	begin
	#10 
		case (Present_state) //assert the required signals in each clockcycle
			Default: begin // initialize the signals
				PCout <= 0; Zlowout <= 0; MDRout <= 0; 
				MARin <= 0; Zin <= 0; // CON_enable<=0; 
				//InPort_enable<=0; OutPort_enable<=0;
				InportIn<=32'h00000011; // grab 2nd instruction
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
						
			//Case 1: 0x87, R1 , want to store 0x87 in memory at the value of R1 (47) memory -> 47 containing 0x87  
			// Case 2: 0x87, R1(R1) , store at 0x87 in memory the cumilitive value in R1 (which will also be 0x87+0x47)

			
T0: begin 
	 PCout <= 1; InportOut <= 1; //Read <= 1; 
end

T1: begin 
		PCout <= 0; InportOut <= 0;  Read <= 0; 
		 Zlowout <= 1;  MDRin <= 1; 
end

T2: begin
	 Zlowout <= 0; Read <= 0; PCout <= 0; MARin <= 0;  MDRin <= 0;
	 MDRout <= 1; 	PCin <= 1; IncPC <=1; 
end

T3: begin
	MDRout <= 0; PCin <= 0; IncPC <=0; 	
	GRB<=1; BAout<=1; MARin <= 1; Zin <= 1; IRin <= 1;  Read <=1;
end

T4: begin
	GRB<=0; BAout<=0; MARin <= 0; Zin <= 0; IRin <= 0; Read <=0;
	Cout<=1; MDRin <= 1;
end

T5: begin
	Cout<=0; MDRin <= 0; 
	Zlowout <= 1; Zin <= 1;  // use y to move to alu and add the register to 
end

T6: begin
	Zlowout <= 0; MARin<=0; Zin <= 0;  MDRin <= 0; InportIn<=32'h000000012;
	MDRout <= 1;  Rin <= 1;  GRA <= 1; 
end
T7: begin
	Read <= 0; MDRout <= 0; Rin <= 0;  GRA <= 0; MARin <= 0;
	 MDRout<=1; Yin <= 1; MARin <= 1;  // 2nd operation Case 2: ld R0, 0x38(R2) 00100038

	
end
// 2nd Part ----------------------------

T8: begin //Loads MDR from RAM output
		MDRout <= 0; GRA <= 0; Rin <= 0; Yin <= 0; MARin <= 0;
		   InportOut <= 1;// Read <= 1;
end

T9: begin
		 Yin <= 0; MARin <= 0; Read <= 0; MDRout<=0; 
		MDRin <= 1; 
end

T10: begin
	MDRin <= 0;MDRout<=0; 
	IRin <= 1; GRB<=1; BAout<=1; Cout <= 1; 
end

T11: begin
	IRin <= 0;  GRB<=0; BAout<=0; Cout <= 0;
	
end

T12: begin
		Zlowout <= 0;  Zin <= 0; PCin <= 0; IncPC <=0; MARin <= 0; Rout <= 0; Read <= 0;
		 MDRin <= 1; MDRout <= 1; 
	  
end

T13: begin

end
T14: begin

end


endcase

end

endmodule
