/*************************************************************
Design Name 	: 
File Name   	: .v
Function    	: 
Coder		    	: 
Last Modified	: 
*************************************************************/

module instr_reg(instr_data,irwr, clk,instr15_12, instr11_8, instr7_4, instr3_0);
	input [15:0] instr_data;
	input irwr,clk;
	output [3:0] instr15_12, instr11_8, instr7_4, instr3_0;

	reg [3:0] instr15_12, instr11_8, instr7_4, instr3_0;

	always @(posedge clk)
	begin
		if(irwr)
		begin
			$display($time,"	At this posedge Instruction register=memory[pc]=%hh",instr_data);
			instr15_12=instr_data[15:12];
			instr11_8=instr_data[11:8];
			instr7_4=instr_data[7:4];
			instr3_0=instr_data[3:0];
		end
	end
	
endmodule
