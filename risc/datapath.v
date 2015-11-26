/*************************************************************
Design Name 	: 
File Name   	: .v
Function    	: 
Coder		    	: 
Last Modified	: 
*************************************************************/

module datapath(opcode,outA,carry,pc_rst,pc_wrt,addr_sel,ir_wrt,data_sel,rega_sel,reg_wrt,opb_sel,opa_sel,alu_sel,re,we,clk);
	input pc_rst,pc_wrt,addr_sel,ir_wrt,rega_sel,reg_wrt,opa_sel,re,we,clk;
	input [1:0] data_sel,opb_sel;
	input [2:0] alu_sel;
	output [3:0] opcode;
	output [15:0] outA;
	output carry;

	wire pc_rst,pc_wrt,ir_wrt,addr_sel,rega_sel,reg_wrt,opa_sel,clk;
	wire [1:0] data_sel,opb_sel;
	wire [2:0] alu_sel;
	wire [3:0] instr15_12,instr11_8,instr7_4,instr3_0, rega;
	wire [15:0] outA,alu_out,alu_rslt,pcin,pcout,address,data_in,data_out,sign_ext8,datain,offsetdata,memout,opa,Ra,adata,Rb,bdata,opb;
	wire [15:0] zero,one;
	wire [15:0] addr_sw;
	
	assign zero = 16'b0;
	assign one = 16'b1;
	assign opcode = instr15_12;
	assign outA = adata;

	//Modules are instantiated
	//mux2_to_1 pcmux(.in0(zero),.in1(alu_rslt),.sel(pc_rst_n),.out(pcin));
	
	pc programcounter(.indata(alu_rslt),.outdata(pcout),.pc_wrt_s2(pc_wrt),.rst(pc_rst),.clk(clk));
	
	mux2_to_1 mux_memory(.in0(pcout),.in1(addr_sw),.sel(addr_sel),.out(address));
	
	ram memory(.clk(clk),.address(address),.data_in(data_in),.data_out(data_out),.re(re),.we(we));// modified in_data,out_data replaces Memdata
	
	instr_reg IR(.instr_data(data_out),.irwr(ir_wrt),.clk(clk),.instr15_12(instr15_12),.instr11_8(instr11_8),.instr7_4(instr7_4),.instr3_0(instr3_0));
	
	mux4b_2_to_1 instrmux(.in0(instr7_4),.in1(instr11_8),.sel(rega_sel),.out(rega));
	
	regfile16 regfile(.add_Rs(rega),.out_Rs(Ra),.add_Rt(instr3_0),.out_Rt(Rb),.add_Rd(instr11_8),.data_wr(datain),.regwr(reg_wrt),.data_sw(data_in),.addr_sw(addr_sw),.clk(clk));
	
	signextender signext(.instr7_4(instr7_4),.instr3_0(instr3_0),.sign_ext8(sign_ext8));
	
	mdr memory_data_reg(.memdatain(data_out),.memdataout(memout),.clk(clk));
	
	mux4_to_1 opbmux(.in0(sign_ext8),.in1(memout),.in2(alu_rslt),.in3(zero),.sel(data_sel),.out(datain));
	
	opa registera(.datain(Ra),.dataout(adata),.clk(clk));
	
	opb registerb(.datain(Rb),.dataout(bdata),.clk(clk));
	
	offset offsetpart(.sign_ext8(sign_ext8),.dataout(offsetdata),.clk(clk));
	
	mux2_to_1 regamux(.in0(adata),.in1(pcout),.sel(opa_sel),.out(opa));
	
	mux4_to_1 regbmux(.in0(bdata),.in1(zero),.in2(one),.in3(offsetdata),.sel(opb_sel),.out(opb));
	
	alu16b alu(.PORT1(opa),.PORT2(opb),.ALUCON(alu_sel),.ALUOUT(alu_out),.carry(carry));
	
	aluout finalout(.datain(alu_out),.dataout(alu_rslt),.clk(clk));
	
endmodule
