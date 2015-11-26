/*************************************************************
Design Name 	: 
File Name   	: .v
Function    	: 
Coder		    	: Control Unit Design
Last Modified	: 
*************************************************************/

module control_unit(opcode,outA,carry,reset,pc_rst,pc_wrt,addr_sel,ir_wrt,data_sel,rega_sel,reg_wrt,opb_sel,opa_sel,alu_sel,re,we,clk);
	output pc_rst,pc_wrt,ir_wrt,addr_sel,rega_sel,reg_wrt,opa_sel,re,we;
	output [1:0] data_sel,opb_sel;
	output [2:0] alu_sel;
	input [3:0] opcode;
	input [15:0] outA;
	input carry, reset, clk;

	reg pc_rst,pc_wrt,ir_wrt,addr_sel,rega_sel,reg_wrt,opa_sel,re,we;
	reg [1:0] data_sel,opb_sel;
	reg [2:0] alu_sel;
	wire [3:0] opcode;
	wire [15:0] outA;
	wire [2:0] alu_task;
	reg [2:0] pstate,nstate;
	wire zero;
	reg FETCH_part_1_done, FETCH_part_2_done, EXECUTE_part_1_done, EXECUTE_part_2_done;

	parameter IDLE=3'b100,FETCH_part_1=3'b000,FETCH_part_2=3'b001,EXECUTE_part_1=3'b010,EXECUTE_part_2=3'b011;
	
	assign zero = ((outA == 16'b0)& ((opcode == 4'b1011) | (opcode == 4'b1100)))?1:0;
	assign alu_task = opcode[2:0];
	
	always @(posedge clk or posedge reset)
	begin
		if(reset)
			pstate = IDLE;
		else 
			pstate = nstate;
	end
	
	always@(pstate or FETCH_part_1_done or FETCH_part_2_done or EXECUTE_part_1_done or EXECUTE_part_2_done)
	begin
		case (pstate)
			IDLE: nstate=FETCH_part_1;
			FETCH_part_1: begin
				if(FETCH_part_1_done)
					nstate=FETCH_part_2;
				else
					nstate = FETCH_part_1;
			end
			FETCH_part_2: begin
				if(FETCH_part_2_done)
					nstate=EXECUTE_part_1;
				else
					nstate = FETCH_part_2;
			end
			EXECUTE_part_1: begin
				if(EXECUTE_part_1_done)
					nstate=EXECUTE_part_2;
				else
					nstate=EXECUTE_part_1;
			end
			EXECUTE_part_2: begin
				if(EXECUTE_part_2_done)
					nstate=FETCH_part_1;
				else
					nstate=EXECUTE_part_2;
			end
			default: nstate = IDLE;
		endcase
	end

	always @(pstate)
	begin
		case(pstate)
			//*****************************************************
			IDLE: begin
				$display("\nCPU is in IDLE state");
				pc_rst <=1'b1;
				pc_wrt <=1'b0;
				addr_sel <=1'b0;
				ir_wrt <=1'b0;
				rega_sel <=1'b0;
				reg_wrt <=1'b0;
				opa_sel <=1'b0;
				re <=1'b0;
				we <=1'b0;
				data_sel <=2'b00;
				opb_sel <=2'b00;
				alu_sel <=3'b000;
				FETCH_part_1_done <= 1'b0;
				FETCH_part_2_done <= 1'b0;
				EXECUTE_part_1_done <= 1'b0;
				EXECUTE_part_2_done <= 1'b0;
			end
			//****************************************************
			FETCH_part_1: begin	//FETCH instruction
				// Retrieve Instruction Word from Main Memory
				//Increment Program Counter and Store in ALU Output
				FETCH_part_1_done <= 1'b0;
				FETCH_part_2_done <= 1'b0;
				EXECUTE_part_1_done <= 1'b0;
				EXECUTE_part_2_done <= 1'b0;
				$display("\nCPU is in FETCH_part_1 state");
				pc_rst<=1'b0;
				pc_wrt<=1'b0;
				addr_sel<=1'b0;
				ir_wrt<=1'b1;
				rega_sel<=1'b0;
				reg_wrt<=1'b0;
				opa_sel<=1'b1;
				re<=1'b1;
				we<=1'b0;
				data_sel<=2'b01;
				opb_sel<=2'b10;
				alu_sel<=3'b000;
				FETCH_part_1_done <= 1'b1;
				FETCH_part_2_done <= 1'b0;
				EXECUTE_part_1_done <= 1'b0;
				EXECUTE_part_2_done <= 1'b0;
			end
			//*****************************************************
			FETCH_part_2: begin	//FETCH operands
				//write incremented Program Count
				//Load Operands into Latches from Register File
				FETCH_part_1_done <= 1'b0;
				FETCH_part_2_done <= 1'b0;
				EXECUTE_part_1_done <= 1'b0;
				EXECUTE_part_2_done <= 1'b0;
				$display("\nCPU is in FETCH_part_2 state");
				casex(opcode)
					4'b0xxx: begin
						pc_rst<=1'b0;
						pc_wrt<=1'b1;
						addr_sel<=1'b0;
						ir_wrt<=1'b0;
						rega_sel<=1'b0;
						reg_wrt<=1'b0;
						opa_sel<=1'b0;
						re<=1'b0;
						we<=1'b0;
						data_sel<=2'b01;
						opb_sel<=2'b00;
						alu_sel<=alu_task;
					end
					4'b1000: begin	// Load Immediate word
						pc_rst<=1'b0;
						pc_wrt<=1'b1;
						addr_sel<=1'b0;
						ir_wrt<=1'b0;
						rega_sel<=1'b0;
						reg_wrt<=1'b0;
						opa_sel<=1'b0;
						re<=1'b0;
						we<=1'b0;
						data_sel<=2'b00;
						opb_sel<=2'b11;
						alu_sel<=3'b000;
					end
					4'b1001: begin// Load Word Operation
						pc_rst<=1'b0;
						pc_wrt<=1'b1;
						addr_sel<=1'b1;
						ir_wrt<=1'b0;
						rega_sel<=1'b0;
						reg_wrt<=1'b0;
						opa_sel<=1'b0;
						re<=1'b0;
						we<=1'b0;
						data_sel<=2'b01;
						opb_sel<=2'b00;
						alu_sel<=3'b000;
					end
					4'b1010: begin//Store Word Operation Keep 11:8 0000
						pc_rst<=1'b0;
						pc_wrt<=1'b1;
						addr_sel<=1'b1;
						ir_wrt<=1'b0;
						rega_sel<=1'b0;
						reg_wrt<=1'b0;
						opa_sel<=1'b0;
						re<=1'b0;
						we<=1'b0;
						data_sel<=2'b01;
						opb_sel<=2'b00;
						alu_sel<=3'b000;
					end
					4'b1011: begin//Branch If zero
						pc_rst<=1'b0;
						pc_wrt<=1'b1;
						addr_sel<=1'b0;
						ir_wrt<=1'b0;
						rega_sel<=1'b1;
						reg_wrt<=1'b0;
						opa_sel<=1'b1;
						re<=1'b0;
						we<=1'b0;
						data_sel<=2'b10;
						opb_sel<=2'b11;
						alu_sel<=3'b000;
					end
					4'b1100: begin//Branch if Not zero
						pc_rst<=1'b0;
						pc_wrt<=1'b1;
						addr_sel<=1'b0;
						ir_wrt<=1'b0;
						rega_sel<=1'b1;
						reg_wrt<=1'b0;
						opa_sel<=1'b1;
						re<=1'b0;
						we<=1'b0;
						data_sel<=2'b10;
						opb_sel<=2'b11;
						alu_sel<=3'b000;
					end
					4'b1101: begin//Jump and link
						pc_rst<=1'b0;
						pc_wrt<=1'b1;
						addr_sel<=1'b0;
						ir_wrt<=1'b0;
						rega_sel<=1'b0;
						reg_wrt<=1'b1;
						opa_sel<=1'b1;
						re<=1'b0;
						we<=1'b0;
						data_sel<=2'b10;
						opb_sel<=2'b11;
						alu_sel<=3'b000;
					end
					4'b1110: begin//Simple Jump
						pc_rst<=1'b0;
						pc_wrt<=1'b1;
						addr_sel<=1'b0;
						ir_wrt<=1'b0;
						rega_sel<=1'b0;
						reg_wrt<=1'b0;
						opa_sel<=1'b1;
						re<=1'b0;
						we<=1'b0;
						data_sel<=2'b01;
						opb_sel<=2'b11;
						alu_sel<=3'b000;
					end
					4'b1111: begin//Jump Return-- PC <= Rs
						pc_rst<=1'b0;
						pc_wrt<=1'b1;
						addr_sel<=1'b0;
						ir_wrt<=1'b0;
						rega_sel<=1'b0;
						reg_wrt<=1'b0;
						opa_sel<=1'b0;
						re<=1'b0;
						we<=1'b0;
						data_sel<=2'b01;
						opb_sel<=2'b01;
						alu_sel<=3'b000;
					end
				endcase
				FETCH_part_1_done <= 1'b0;
				FETCH_part_2_done <= 1'b1;
				EXECUTE_part_1_done <= 1'b0;
				EXECUTE_part_2_done <= 1'b0;
			end
			//*****************************************************
			EXECUTE_part_1: begin
				//Perform ALU Operation based instruction word and store in ALU Out
				//Move Memory Word into MDR for Load Word operation
				//Write Data into Memory from Register File for Store Word operation
				FETCH_part_1_done <= 1'b0;
				FETCH_part_2_done <= 1'b0;
				EXECUTE_part_1_done <= 1'b0;
				EXECUTE_part_2_done <= 1'b0;
				$display("\nCPU is in EXECUTE_part_1 state");
				casex(opcode)
					4'b0xxx: begin
						pc_rst<=1'b0;
						pc_wrt<=1'b0;
						addr_sel<=1'b0;
						ir_wrt<=1'b0;
						rega_sel<=1'b0;
						reg_wrt<=1'b0;
						opa_sel<=1'b0;
						re<=1'b0;
						we<=1'b0;
						data_sel<=2'b01;
						opb_sel<=2'b00;
						alu_sel<=alu_task;
					end
					4'b1000: begin // Load Immediate word operation
						pc_rst<=1'b0;
						pc_wrt<=1'b0;
						addr_sel<=1'b0;
						ir_wrt<=1'b0;
						rega_sel<=1'b0;
						reg_wrt<=1'b1;
						opa_sel<=1'b0;
						re<=1'b0;
						we<=1'b0;
						data_sel<=2'b00;
						opb_sel<=2'b11;
						alu_sel<=3'b000;
					end
					4'b1001: begin// Load Word Operation
						pc_rst<=1'b0;
						pc_wrt<=1'b0;
						addr_sel<=1'b1;
						ir_wrt<=1'b0;
						rega_sel<=1'b0;
						reg_wrt<=1'b0;
						opa_sel<=1'b0;
						re<=1'b1;
						we<=1'b0;
						data_sel<=2'b01;
						opb_sel<=2'b00;
						alu_sel<=3'b000;
					end
					4'b1010: begin//Store Word Operation Keep 11:8 0000
						pc_rst<=1'b0;
						pc_wrt<=1'b0;
						addr_sel<=1'b1;
						ir_wrt<=1'b0;
						rega_sel<=1'b0;
						reg_wrt<=1'b0;
						opa_sel<=1'b0;
						re<=1'b0;
						we<=1'b1;
						data_sel<=2'b01;
						opb_sel<=2'b00;
						alu_sel<=3'b000;
					end
					4'b1011: begin//Branch If Zero
						pc_rst<=1'b0;
						pc_wrt<=1'b0;
						addr_sel<=1'b0;
						ir_wrt<=1'b0;
						rega_sel<=1'b1;
						reg_wrt<=1'b0;
						opa_sel<=1'b1;
						re<=1'b0;
						we<=1'b0;
						data_sel<=2'b01;
						opb_sel<=2'b11;
						alu_sel<=3'b000;
					end
					4'b1100: begin//Branch If not Zero
						pc_rst<=1'b0;
						pc_wrt<=1'b0;
						addr_sel<=1'b0;
						ir_wrt<=1'b0;
						rega_sel<=1'b1;
						reg_wrt<=1'b0;
						opa_sel<=1'b1;
						re<=1'b0;
						we<=1'b0;
						data_sel<=2'b01;
						opb_sel<=2'b11;
						alu_sel<=3'b000;
					end
					4'b1101: begin//Jump and Link
						pc_rst<=1'b0;
						pc_wrt<=1'b0;
						addr_sel<=1'b0;
						ir_wrt<=1'b0;
						rega_sel<=1'b0;
						reg_wrt<=1'b0;
						opa_sel<=1'b1;
						re<=1'b0;
						we<=1'b0;
						data_sel<=2'b01;
						opb_sel<=2'b11;
						alu_sel<=3'b000;
					end
					4'b1110: begin// Simple Jump
						pc_rst<=1'b0;
						pc_wrt<=1'b0;
						addr_sel<=1'b0;
						ir_wrt<=1'b0;
						rega_sel<=1'b0;
						reg_wrt<=1'b0;
						opa_sel<=1'b1;
						re<=1'b0;
						we<=1'b0;
						data_sel<=2'b01;
						opb_sel<=2'b11;
						alu_sel<=3'b000;
					end
					4'b1111: begin// Jump Return
						pc_rst<=1'b0;
						pc_wrt<=1'b0;
						addr_sel<=1'b0;
						ir_wrt<=1'b0;
						rega_sel<=1'b0;
						reg_wrt<=1'b0;
						opa_sel<=1'b0;
						re<=1'b0;
						we<=1'b0;
						data_sel<=2'b01;
						opb_sel<=2'b01;
						alu_sel<=3'b000;
					end
				endcase
				FETCH_part_1_done <= 1'b0;
				FETCH_part_2_done <= 1'b0;
				EXECUTE_part_1_done <= 1'b1;
				EXECUTE_part_2_done <= 1'b0;
			end
			//*****************************************************
			EXECUTE_part_2: begin
				//Write ALU, IR (Immediate), or MDR data into Register File
				//Write new Program Count for Jump Operation or it Branch taken
				FETCH_part_1_done <= 1'b0;
				FETCH_part_2_done <= 1'b0;
				EXECUTE_part_1_done <= 1'b0;
				EXECUTE_part_2_done <= 1'b0;
				$display("\nCPU is in EXECUTE_part_2 state");
				casex(opcode)
					4'b0xxx: begin
						pc_rst<=1'b0;
						pc_wrt<=1'b0;
						addr_sel<=1'b0;
						ir_wrt<=1'b0;
						rega_sel<=1'b0;
						reg_wrt<=1'b1;
						opa_sel<=1'b0;
						re<=1'b0;
						we<=1'b0;
						data_sel<=2'b10;
						opb_sel<=2'b00;
						alu_sel<=alu_task;
					end
					4'b1000: begin // Load Immediate word
						pc_rst<=1'b0;
						pc_wrt<=1'b0;
						addr_sel<=1'b0;
						ir_wrt<=1'b0;
						rega_sel<=1'b0;
						reg_wrt<=1'b1;
						opa_sel<=1'b0;
						re<=1'b0;
						we<=1'b0;
						data_sel<=2'b00;
						opb_sel<=2'b11;
						alu_sel<=3'b000;
					end
					4'b1001: begin// Load Word Operation
						pc_rst<=1'b0;
						pc_wrt<=1'b0;
						addr_sel<=1'b1;
						ir_wrt<=1'b0;
						rega_sel<=1'b0;
						reg_wrt<=1'b1;
						opa_sel<=1'b0;
						re<=1'b1;
						we<=1'b0;
						data_sel<=2'b01;
						opb_sel<=2'b00;
						alu_sel<=3'b000;
					end
					4'b1010: begin//Store Word Operation Keep 11:8 0000
						pc_rst<=1'b0;
						pc_wrt<=1'b0;
						addr_sel<=1'b1;
						ir_wrt<=1'b0;
						rega_sel<=1'b0;
						reg_wrt<=1'b0;
						opa_sel<=1'b0;
						re<=1'b0;
						we<=1'b1;
						data_sel<=2'b01;
						opb_sel<=2'b00;
						alu_sel<=3'b000;
					end
					4'b1011: begin//Branch If Zero
						pc_rst<=1'b0;
						pc_wrt<=zero;
						addr_sel<=1'b0;
						ir_wrt<=1'b0;
						rega_sel<=1'b1;
						reg_wrt<=1'b0;
						opa_sel<=1'b1;
						re<=1'b0;
						we<=1'b0;
						data_sel<=2'b01;
						opb_sel<=2'b11;
						alu_sel<=3'b000;
					end
					4'b1100: begin//Branch if not zero
						pc_rst<=1'b0;
						pc_wrt<=~zero;
						addr_sel<=1'b0;
						ir_wrt<=1'b0;
						rega_sel<=1'b1;
						reg_wrt<=1'b0;
						opa_sel<=1'b1;
						re<=1'b0;
						we<=1'b0;
						data_sel<=2'b01;
						opb_sel<=2'b11;
						alu_sel<=3'b000;
					end
					4'b1101: begin//Jump and Link
						pc_rst<=1'b0;
						pc_wrt<=1'b1;
						addr_sel<=1'b0;
						ir_wrt<=1'b0;
						rega_sel<=1'b0;
						reg_wrt<=1'b0;
						opa_sel<=1'b1;
						re<=1'b0;
						we<=1'b0;
						data_sel<=2'b01;
						opb_sel<=2'b11;
						alu_sel<=3'b000;
					end
					4'b1110: begin//Simple Jump
						pc_rst<=1'b0;
						pc_wrt<=1'b1;
						addr_sel<=1'b0;
						ir_wrt<=1'b0;
						rega_sel<=1'b0;
						reg_wrt<=1'b0;
						opa_sel<=1'b1;
						re<=1'b0;
						we<=1'b0;
						data_sel<=2'b01;
						opb_sel<=2'b11;
						alu_sel<=3'b000;
					end
					4'b1111: begin//Jump Return
						pc_rst<=1'b0;
						pc_wrt<=1'b1;
						addr_sel<=1'b0;
						ir_wrt<=1'b0;
						rega_sel<=1'b0;
						reg_wrt<=1'b0;
						opa_sel<=1'b0;
						re<=1'b0;
						we<=1'b0;
						data_sel<=2'b01;
						opb_sel<=2'b01;
						alu_sel<=3'b000;
					end
				endcase
				FETCH_part_1_done <= 1'b0;
				FETCH_part_2_done <= 1'b0;
				EXECUTE_part_1_done <= 1'b0;
				EXECUTE_part_2_done <= 1'b1;
			end
		endcase
	end
	
endmodule
