/*************************************************************
Design Name 	: 
File Name   	: .v
Function    	: 
Coder		    	: 
Last Modified	: 
*************************************************************/

module pc(indata,outdata,pc_wrt_s2,rst,clk);
	input [15:0]indata;
	input clk,pc_wrt_s2,rst;
	output [15:0] outdata;

	reg [15:0] outdata;

	always @ (posedge clk or posedge rst)
	begin
		if(rst)
		begin
			outdata = 16'b0;
			$display($time,"	At this posedge contents of pc are %hh",outdata);
		end
		else
		begin
			if(pc_wrt_s2)
			begin
				outdata=indata;
				$display($time,"	At this posedge contents of pc are %hh",outdata);
			end
		end
	end
	
endmodule
