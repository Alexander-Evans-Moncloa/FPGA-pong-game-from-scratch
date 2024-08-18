///////////////////////////////////////////////////////////////
// Authors: ANONYMOUS and Alexander Evans Moncloa
// Date: 13/12/2022
// Module name: VgaController
// Description: Controls VGA Display output
///////////////////////////////////////////////////////////////

module VgaController
(
	input	logic	Clock,
	input	logic	Reset,
	output	logic	blank_n,
	output	logic	sync_n,
	output	logic	hSync_n,
	output	logic vSync_n,
	output	logic	[10:0] nextX,
	output	logic	[ 9:0] nextY
);

	// use this signal as counter for the horizontal axis 
	logic [10:0] hCount;

	// use this signal as counter for the vertical axis
	logic [ 9:0] vCount;

	
	always_comb
begin

if((hCount < 800)&(vCount < 600))
				blank_n <= 1;
			else
				blank_n <= 0;

			if ((hCount > 855) & (hCount < 976))
				begin
				hSync_n <= 0;
				sync_n <= 0;
				end
			else
				begin
				hSync_n <= 1;
				sync_n <= 1;
				end

			if ((vCount > 636) & (vCount < 643))
				begin
				vSync_n <= 0;
				sync_n <= 0;
				end
			else
				begin
				vSync_n <= 1;
				sync_n <= 1;
				end






end


	
	always_ff @(posedge Clock)
	   begin
			
			//nextX <= nextX + 1;
			//if(nextX > 1039)
			//begin
			//	nextX <= 0;
			//	//nextY <= nextY + 1;
			//	if (nextY > 665)
			//		nextY <= 0;
			//end
			
			
			
			if(hCount <= 1039)
				hCount <= hCount + 1;
			else
				begin
				hCount <= 0;
				vCount <= vCount + 1;
				end
			if(hCount > 1039 & vCount > 665)
				vCount <= 0;
				
			if(hCount<800)nextX = hCount;
			else nextX = 0;
			
			if(vCount<600)nextY = vCount;
			else nextY =0;
			
			
		end	
	
	
	
	
	

endmodule
