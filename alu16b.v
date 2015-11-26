/*************************************************************
Design Name 	: 
File Name   	: .v
Function    	: ALU Behavioural
Coder		    	: 
Last Modified	: 
*************************************************************/

module alu16b(PORT1, PORT2, ALUCON, ALUOUT, carry);
	input [15:0]PORT1,PORT2;
	input [2:0] ALUCON;
	output carry;
	output [15:0] ALUOUT;

	reg [15:0] ALUOUT;
	reg carry,temp;

	always @(ALUCON or PORT1 or PORT2)
	begin
		case (ALUCON[2:0])
			3'b000 : begin
				{temp,ALUOUT} = PORT1 + PORT2; //do add
				//generate appropriate carry for the purpose of slt especially
				if(PORT1[15]==PORT2[15])
					carry=temp;
				else
				begin
					if(PORT1[15]==1)
						carry=1;
					else
						carry=0;
				end
			end
			3'b001 : begin
				{temp,ALUOUT} = PORT1 - PORT2; // do subtract
				//generate appropriate carry for the purpose of slt especially
				if(PORT1[15]==PORT2[15])
					carry=temp;
				else
				begin
					if(PORT1[15]==1)
						carry=1;
					else
						carry=0;
				end
			end
			3'b010 : begin ALUOUT = PORT1 & PORT2;temp=0;carry=0; end // do and operation
			3'b011 : begin ALUOUT = PORT1 | PORT2;temp=0;carry=0; end // do or operation
			3'b100 : begin ALUOUT = PORT1 ^ PORT2;temp=0;carry=0; end // do xor operation
			3'b101 : begin ALUOUT = ~PORT1 ;temp=0;carry=0; end // do not operation
			3'b110 : begin ALUOUT = PORT1 << 1;temp=0;carry=0; end // do SLA operation
			3'b111 : begin ALUOUT = PORT1 >> 1;temp=0;carry=0; end // do SRA operation
		endcase
	end
	
endmodule
