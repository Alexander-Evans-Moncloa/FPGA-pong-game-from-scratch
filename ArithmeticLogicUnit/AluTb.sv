///////////////////////////////////////////////////////////////
// Authors: ANONYMOUS and Alexander Evans Moncloa
// Date: 13/12/2022
// Module name: AluTb
// Description: Arithmetic Logic Unit Testbench
///////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

import InstructionSetPkg::*;

// This module implements a set of tests that 
// partially verify the ALU operation.
module AluTb();

	eOperation Operation;
	
	sFlags    InFlags;
	sFlags    OutFlags;
	
	logic signed [ImmediateWidth-1:0] InImm = '0;
	
	logic	signed [DataWidth-1:0] InSrc  = '0;
	logic signed [DataWidth-1:0] InDest = '0;
	
	logic signed [DataWidth-1:0] OutDest;

	ArithmeticLogicUnit uut (.*);

	initial
	begin
		InFlags = sFlags'(0);
	

		$display("Start of NAND tests");
		Operation = NAND;
		
		InDest = 16'h0000;
		InSrc  = 16'ha5a5;      
	   #1 if (OutDest != 16'hFFFF) $display("Error in NAND operation at time %t",$time);
		
		#10 InDest = 16'h9999; 
	   #1 if (OutDest != 16'h7E7E) $display("Error in NAND operation at time %t",$time);
		
		#10 InDest = 16'hFFFF; 
	   #1 if (OutDest != 16'h5a5a) $display("Error in NAND operation at time %t",$time);
		
		#10 InDest = 16'h1234; 
	   #1 if (OutDest != 16'hFFDB) $display("Error in NAND operation at time %t",$time);
		
		#10 InSrc = 16'h0000;   
		InDest = 16'ha5a5;     
	   #1 if (OutDest != 16'hFFFF) $display("Error in NAND operation at time %t",$time);
		
		#10 InSrc = 16'h9999;  
	   #1 if (OutDest != 16'h7E7E) $display("Error in NAND operation at time %t",$time);
		
		#10 InSrc = 16'hFFFF; 
	   #1 if (OutDest != 16'h5a5a) $display("Error in NAND operation at time %t",$time);
		
		#10 InSrc = 16'h1234;  
	   #1 if (OutDest != 16'hFFDB) $display("Error in NAND operation at time %t",$time);
		#50;

				
		
		$display("Start of ADC tests");
		Operation = ADC;
		
		InDest = 16'h0000;
		InSrc = 16'ha5a5;
	   #1 
		if (OutDest != 16'ha5a5) $display("Error in ADC operation at time %t",$time);
	   if (OutFlags != sFlags'(12)) $display("Error 1 (flags) in ADC operation at time %t %b",$time,OutFlags); 
		
		#10 InFlags.Carry = '1;
	   #1 
		if (OutDest != 16'ha5a6) $display("Error in ADC operation at time %t",$time);
	   if (OutFlags != sFlags'(12)) $display("Error 2 (flags) in ADC operation at time %t %b",$time,OutFlags);

		#10 InDest = 16'h5a5a; 
	   #1 
		if (OutDest != 16'h0000) $display("Error in ADC operation at time %t",$time);
	   if (OutFlags != sFlags'(11)) $display("Error 3 (flags) in ADC operation at time %t %b",$time,OutFlags);
		
		#10 InDest = 16'h8000;
		InFlags.Carry = '0;
		InSrc = 16'hffff;      
	   #1 
		if (OutDest != 16'h7fff) $display("Error in ADC operation at time %t",$time);
	   if (OutFlags != sFlags'(17)) $display("Error 4 (flags) in ADC operation at time %t %b",$time,OutFlags);
		
		#10 InDest = 16'h7fff;
		InSrc = 16'h0001;     
	   #1 
		if (OutDest != 16'h8000) $display("Error in ADC operation at time %t",$time);
	   if (OutFlags != sFlags'(20)) $display("Error 5 (flags) in ADC operation at time %t %b",$time,OutFlags);
		#50;



		
		$display("Start of LIU tests");
		Operation = LIU;
		
		InDest = 16'h0000;
		InImm = 6'h3F;          
	   #1 if (OutDest != 16'hF800) $display("Error in LIU operation at time %t",$time);
		
		#10 InImm = 6'h0F;      
	   #1 if (OutDest != 16'h03C0) $display("Error in LIU operation at time %t",$time);
		
		#10 InDest = 16'hAAAA;  		
	   #1 if (OutDest != 16'h03EA) $display("Error in LIU operation at time %t",$time);
		
		#10 InImm = 6'h3F;      
	   #1 if (OutDest != 16'hFAAA) $display("Error in LIU operation at time %t",$time);
		#50;
	

		// Put your code here to verify the instructions.






		$display("Start of MOVE tests");
		Operation = MOVE;
		
		InSrc = 16'h0000;         
	   #1 if (OutDest != 16'h0000) $display("Error in MOVE operation at time %t",$time);
		//else $display("Success! InSrc value is equal to %b, and OutDest is equal to %b", InSrc, OutDest);

		#10 InSrc = 16'hFFFF;      
	   #1 if (OutDest != 16'hFFFF) $display("Error in MOVE operation at time %t",$time);
		//else $display("Success! InSrc value is equal to %b, and OutDest is equal to %b", InSrc, OutDest);






		$display("Start of NOR tests");
		Operation = NOR;
		
		InDest = 16'h0000;
		InSrc = 16'h0000;         
	   #1 if (OutDest != 16'hFFFF) $display("Error in NOR operation. InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);
		//else $display("Success! InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);

		#10 InSrc = 16'b0110100011110101;    
	   #1 if (OutDest != 16'b1001011100001010) $display("Error in NOR operation. InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);
		//else $display("Success! InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);
		



		$display("Start of ROL tests");
		Operation = ROL;
		
		InDest = 16'h0011;
		InSrc = 16'h00AB;         
	   	#1 if (OutDest != 16'b0000000101010110) $display("Error in ROL operation. InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);
		//else $display("Success! InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);
		#1 if (OutFlags != sFlags'(0)) $display("Error (flags) in ROL operation at time %t",$time);

		#10 InSrc = 16'b0110100011110101;    
	   	#1 if (OutDest != 16'b1101000111101010) $display("Error in ROL operation. InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);
		//else $display("Success! InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);
		#1 if (OutFlags != sFlags'(0)) $display("Error (flags) in ROL operation at time %t",$time);






		$display("Start of ROR tests");
		Operation = ROR;
		
		InDest = 16'h0011;
		InSrc = 16'h00AB;         
	   	#1 if (OutDest != 16'b0000000001010101) $display("Error in ROR operation. InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);
		//else $display("Success! InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);
		#1 if (OutFlags != sFlags'(1)) $display("Error (flags) in ROR operation at time %t",$time);

		#10 InSrc = 16'b0110100011110101;    
	   	#1 if (OutDest != 16'b0011010001111010) $display("Error in ROR operation. InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);
		//else $display("Success! InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);
		#1 if (OutFlags != sFlags'(1)) $display("Error (flags) in ROR operation at time %t",$time);






		$display("Start of LIL tests");
		Operation = LIL;
		
		InDest = 16'h0000;
		InImm = 6'h3F;          
	   #1 if (OutDest != 16'hffff) $display("Error in LIL operation at time %t,%h",$time,OutDest);
		
		#10 InImm = 6'h0F;      
	   #1 if (OutDest != 16'h000f) $display("Error in LIL operation at time %t,%h",$time, OutDest);
		
		#10 InDest = 16'hAAAA;  		
	   #1 if (OutDest != 16'h000f) $display("Error in LIL operation at time %t,%h",$time, OutDest);
		
		#10 InImm = 6'h3F;      
	   #1 if (OutDest != 16'hffff) $display("Error in LIL operation at time %t,%h",$time, OutDest);
		#50;



		$display("Start of SUB tests");
		Operation = SUB;
		
		InDest = 16'h00AB;
		InSrc = 16'h0011;         
	   	#1 if (OutDest != 16'b0000000010011010) $display("Error in SUB operation. InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);
		#1 if (OutFlags != sFlags'(8)) $display("Error (flags) in SUB operation at time %t, %b",$time,OutFlags);

		#10 InSrc = 16'h00A2;    
	   	#1 if (OutDest != 16'b0000000000001001) $display("Error in SUB operation. InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);
		#1 if (OutFlags != sFlags'(8)) $display("Error (flags) in SUB operation at time %t, %b",$time,OutFlags);



		$display("Start of DIV tests");
		Operation = DIV;
		
		InDest = 16'h6D64;
		InSrc = 16'h0004;         
	   #1 if (OutDest != 16'h1B59) $display("Error in DIV operation. InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);
		//else $display("Success! InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);
		#1 if (OutFlags != sFlags'(8)) $display("Error (flags) in DIV operation at time %t",$time);

		#10 InDest = 16'h0004;
		InSrc = 16'h0002;         
	   #1 if (OutDest != 16'h0002) $display("Error in DIV operation. InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);
		//else $display("Success! InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);
		#1 if (OutFlags != sFlags'(0)) $display("Error 1 (flags) in DIV operation at time %t",$time);



		$display("Start of MOD tests");
		Operation = MOD;
		
		InDest = 16'h6D65;
		InSrc = 16'h0004;         
	   #1 if (OutDest != 16'b0000000000000001) $display("Error in MOD operation. InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);
		//else $display("Success! InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);
		#1 if (OutFlags != sFlags'(0)) $display("Error (flags) in MOD operation at time %t",$time);

		#10 InDest = 16'h000A;
		InSrc = 16'h0014;         
	   #1 if (OutDest != 16'h000A) $display("Error in MOD operation. InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);
		//else $display("Success! InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);
		#1 if (OutFlags != sFlags'(8)) $display("Error (flags) in MOD operation at time %t",$time);




		$display("Start of MUL tests");
		Operation = MUL;
		
		InDest = 16'h5A94;
		InSrc = 16'h755B;         
	   #1 if (OutDest != 16'hD69C) $display("Error in MUL operation. InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);
		//else $display("Success! InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);
		#1 if (OutFlags != sFlags'(4)) $display("Error (flags) in MUL operation at time %t",$time);




		$display("Start of MUH tests");
		Operation = MUH;
		
		InDest = 16'h5A94;
		InSrc = 16'h755B;         
	   #1 if (OutDest != 16'h2985) $display("Error in MUH operation. InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);
		//else $display("Success! InDest = %b, InSrc = %b, OutDest = %b", InDest, InSrc, OutDest);
		#1 if (OutFlags != sFlags'(8)) $display("Error 1 (flags) in ADC operation at time %t",$time);

		// End of instruction simulation

		$display("End of tests");
	end
endmodule
