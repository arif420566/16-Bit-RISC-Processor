/*************************************************************
Design Name 	: risc
File Name   	: risc.v
Function    	: Top level Module RISC
Coder		    	: 
Last Modified	: 07-11-2015
*************************************************************/

module risc(clk,reset);
	input clk,reset;
	
	wire [3:0]opcode;
	wire [2:0] alu_sel;
	wire [1:0] opb_sel,data_sel;
	wire [15:0] outA;
	wire carry,pc_rst,addr_sel,pc_wrt,ir_wrt,rega_sel,reg_wrt,opa_sel,re,we;

	control_unit control_path(opcode,outA,carry,reset,pc_rst,pc_wrt,addr_sel,ir_wrt,data_sel,rega_sel,reg_wrt,opb_sel,opa_sel,alu_sel,re,we,clk);
	
	datapath data_path(opcode,outA,carry,pc_rst,pc_wrt,addr_sel,ir_wrt,data_sel,rega_sel,reg_wrt,opb_sel,opa_sel,alu_sel,re,we,clk);
	
endmodule
