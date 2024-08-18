///////////////////////////////////////////////////////////////
// Authors: ANONYMOUS and Alexander Evans Moncloa
// Date: 13/12/2022
// Module name: RegisterFile
// Description: The code for the register creation
///////////////////////////////////////////////////////////////

module RegisterFile(
	input  logic  Clock = 0,
	input  logic [5:0]  AddressA,
	output logic [15:0] ReadDataA,
	input  logic [15:0] WriteData,
	input logic        WriteEnable,
	input logic [5:0]  AddressB,
	output logic [15:0] ReadDataB
);

logic [15:0] Registers [64];




always_ff @(posedge Clock)
begin
	if(WriteEnable == 1)
		begin
			Registers[AddressA] <= WriteData ;
		end
end

always_comb
begin
	ReadDataA = Registers[AddressA];
	ReadDataB = Registers[AddressB];
end

endmodule
