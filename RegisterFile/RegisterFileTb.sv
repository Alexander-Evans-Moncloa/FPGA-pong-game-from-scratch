/////////////////////////////////////////////////////////////////
// Authors: ANONYMOUS and Alexander Evans Moncloa
// Date: 13/12/2022
// Module name: RegisterFile
// Description: Testbench for the register file
///////////////////////////////////////////////////////////////

module RegisterFileTb();
	logic        Clock = 0;
	logic [5:0]  AddressA;
	logic [15:0] ReadDataA;
	logic [15:0] WriteData;
	logic        WriteEnable;
	logic [5:0]  AddressB;
	logic [15:0] ReadDataB;

	RegisterFile uut(.*);
	default clocking @(posedge Clock);
	endclocking	
	always #20 Clock++;

	initial 
	begin

	Clock = '0; AddressA = '0; WriteData = '0; WriteEnable = '0; AddressB = '0;

	#10;
	WriteEnable = '1;

	#10; 
	AddressA = 6'h01; //load random data
	WriteData = 16'h0002;

	#10;
	WriteEnable = '1;
	
	#10;
	WriteEnable = '1;
	WriteData = 16'h0003;

	#10;
	WriteEnable = '0;
	WriteData = 16'hFFFF; //Should NOT write this into AddressA
	
	#10;
	WriteEnable = '1;
	WriteData = 16'h0004;

	#10;
	WriteEnable = '1;
	AddressB = 6'hFF; //Writes big number into AddressB
	WriteData = 16'hF5F5;

	#10;
	WriteEnable = '1;
	AddressA = 6'hEE; //Writes an almost as big into AddressA
	WriteData = 16'h0008;

	end

endmodule
