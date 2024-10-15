module RAM(input write, input clk, input [31:0] MDRdata, input[8:0] addr, output [31:0] q);

   reg [31:0] ram[511:0];
	
	initial
		$readmemh("ram.txt", ram);  

	
	//(* ram_init_file = "my_init_file.mif" *) reg [31:0] ram[0:511];

	

	always @(posedge clk)
	begin
		if (write) begin
			ram[addr] <= MDRdata;
	end
end	
	assign q = ram[addr]; // changed to addr
endmodule