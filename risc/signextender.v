/*************************************************************
Design Name 	: 
File Name   	: .v
Function    	: 
Coder		    	: 
Last Modified	: 
*************************************************************/

module signextender(instr7_4,instr3_0,sign_ext8);
	input [3:0] instr7_4,instr3_0;
	output [15:0] sign_ext8;

	reg [15:0] sign_ext8;
	wire [7:0] A,B;
	wire [7:0] in;

	assign in={instr7_4,instr3_0};
	assign A=8'b11111111;
	assign B=8'b00000000;

	always @ (in)
	begin
		if (in[7]==0)//use the msb to determine extension bits
			sign_ext8={B,in};
		else
			sign_ext8={A,in};
	end

endmodule
