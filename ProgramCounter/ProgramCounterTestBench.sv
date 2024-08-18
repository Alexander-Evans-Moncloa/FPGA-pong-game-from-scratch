///////////////////////////////////////////////////////////////
// Authors: ANONYMOUS and Alexander Evans Moncloa
// Date: 13/12/2022
// Module name: ProgramCounterTestBench
// Description: Test bench for the program counter, jumps up to 104 in lots of 16, stays at 1 for a while, jumps to 9999 then decreases by 1 each clock cycle
///////////////////////////////////////////////////////////////

module ProgramCounterTestBench();

	// These are the signals that connect to 
	// the program counter
	logic              	Clock = '0;
	logic              	Reset;
	logic signed       [15:0]	LoadValue;
	logic				LoadEnable;
	logic signed  [8:0]	Offset;
	logic 					OffsetEnable;
	logic signed  [15:0]	CounterValue;

	// this is another method to create an instantiation
	// of the program counter
	ProgramCounter uut
	(
		.Clock,
		.Reset,
		.LoadValue,
		.LoadEnable,
		.Offset,
		.OffsetEnable,
		.CounterValue
	);
	

	default clocking @(posedge Clock);
	endclocking
		
	always  #10  Clock++;

	initial
	begin

	// add your code here to test the functionality
	// of your program counter

	#10 Reset = 0; LoadEnable = 0; OffsetEnable = 0;
	$monitor("Reset = %b, LoadEnable = %b, OffsetEnable = %b",Reset,LoadEnable,OffsetEnable);
	#10 Reset = 1; LoadEnable = 0; OffsetEnable = 0;
	
	//#10 Reset = 0; LoadEnable = 1; OffsetEnable = 0; LoadValue=16;
		
	#10 Reset = 1; LoadEnable = 1; OffsetEnable = 0;
	
	//#10 Reset = 0; LoadEnable = 0; OffsetEnable = 1;  Offset = 8;
		
	#10 Reset = 0; LoadEnable = 0; OffsetEnable = 1;  Offset = 16;
		

	#100 Reset = 0; LoadEnable = 1; OffsetEnable = 0; LoadValue= 1;

	#100 Reset = 0; LoadEnable = 1; LoadValue = 9999;
	#10 LoadEnable = 0; OffsetEnable = 1; Offset = -1;  


	//#10 Reset = 0; LoadEnable = 0; OffsetEnable = 1;
	
	//#10 Reset = 1; LoadEnable = 1; OffsetEnable = 1;


	// you need test different values for the input signals:
	// Reset, LoadValue, LoadEnable, OffsetEnable
	// and Offet. Then, you can check whether the output signal
	// CounterValue shows the correct value, otherwise, you need
	// to fix your ProgramCounter module.
	
	end
endmodule
	
