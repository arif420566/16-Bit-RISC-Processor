/*************************************************************
Design Name 	: 
File Name   	: .v
Function    	: 
Coder		    	: 
Last Modified	: 
*************************************************************/

module offset(sign_ext8,dataout,clk);
	input [15:0] sign_ext8;
	input clk;
	output [15:0] dataout;

	reg [15:0] dataout;

	always @ (posedge clk)
	begin
		dataout=sign_ext8;
		$display($time,"	At this posedge register OFFSET=%hh",dataout);
	end
	
endmodule
