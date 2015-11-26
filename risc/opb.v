/*************************************************************
Design Name 	: 
File Name   	: .v
Function    	: 
Coder		    	: 
Last Modified	: 
*************************************************************/

module opb(datain,dataout,clk);
	input [15:0] datain;
	input clk;
	output [15:0] dataout;
	
	reg [15:0] dataout;
	
	always @ (posedge clk)
	begin
		dataout=datain;
		$display($time,"	At this posedge register B=%hh",dataout);
	end
	
endmodule
