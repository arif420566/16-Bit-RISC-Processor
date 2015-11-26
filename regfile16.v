/*************************************************************
Design Name 	: 
File Name   	: .v
Function    	: Register File which contains 16 Register of 16 bits
Coder		    	: 
Last Modified	: 
*************************************************************/

module regfile16(add_Rs, out_Rs, add_Rt, out_Rt, add_Rd, data_wr, regwr,data_sw,addr_sw,clk);
	input [3:0] add_Rs, add_Rt, add_Rd;
	input regwr, clk;
	input [15:0] data_wr;
	output [15:0] out_Rs, out_Rt,data_sw,addr_sw;
	
	reg[15:0] Register[0:15];
	reg [15:0] out_Rs, out_Rt;
	wire [15:0] addr_sw,data_sw;

	assign addr_sw = out_Rs;
	assign data_sw = out_Rt;

	always @ (posedge clk)
	begin
		if(regwr)
		begin
			if (add_Rd == 4'b0)
				Register[add_Rd] = 16'b0;//if it is zero ,the output must be zero only
			else
				Register[add_Rd] = data_wr;
		$display("At this posedge Register %d of Regfile is written %h",add_Rd,data_wr);
		end
	end

	always @ (add_Rs or add_Rt)
	begin
		if (add_Rs ==4'b0)
			out_Rs = 16'b0;// if it is zero register,then give the content as zero only
		else
			out_Rs = Register[add_Rs];
		
		if (add_Rt == 4'b0)
			out_Rt = 16'b0;// if it is zero register,then give the content as zero only
		else
			out_Rt = Register[add_Rt];
	end
	
endmodule
