/*************************************************************
Design Name 	: 
File Name   	: .v
Function    	: 
Coder		    	: 
Last Modified	: 
*************************************************************/

module mdr(memdatain,memdataout,clk);
	input [15:0] memdatain;
	input clk;
	output [15:0] memdataout;

	reg [15:0]memdataout;

	always @ (posedge clk)
	begin
		memdataout=memdatain;
	end

endmodule
