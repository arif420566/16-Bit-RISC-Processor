module RISC_TB;

	reg CLK, RESET;
	
	risc RISC(CLK,RESET);
	
	initial
	begin
		CLK = 1'b0;
		forever #5 CLK = ~CLK; 
	end
	
	initial
	begin
			RESET = 1'b1;
		#50 	RESET = 1'b0;
		#1000	$finish;
	end
	
endmodule
