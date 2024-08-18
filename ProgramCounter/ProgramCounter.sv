///////////////////////////////////////////////////////////////
// Authors: ANONYMOUS and Alexander Evans Moncloa
// Date: 13/12/2022
// Module name: ProgramCounter
// Description: An program that counts
///////////////////////////////////////////////////////////////


module ProgramCounter 
( 
		input logic Clock,
		input logic Reset,
		input logic signed[15:0]LoadValue,
		input logic LoadEnable,
		input logic signed [8:0]Offset,
		input logic OffsetEnable,
		output logic signed[15:0]CounterValue 
);
logic signed[15:0]Nextvalue;

always_ff @(posedge Clock)
begin

	if(Reset == 1)CounterValue <= 0;
			
	else
		CounterValue = Nextvalue;
end

always_comb
begin
	if(LoadEnable == 1)
			begin
				Nextvalue = LoadValue;
			end
			
		
			
		else if(OffsetEnable == 1 )
			begin
				Nextvalue = CounterValue + Offset;
			end
		
			
		else
			begin
				Nextvalue = CounterValue + 1;
			end
end


endmodule 