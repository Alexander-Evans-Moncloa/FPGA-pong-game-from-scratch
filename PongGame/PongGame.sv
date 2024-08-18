///////////////////////////////////////////////////////////////
// Authors: ANONYMOUS and Alexander Evans Moncloa
// Date: 13/12/2022
// Module name: PongGame
// Description: A game of pong
///////////////////////////////////////////////////////////////

module PongGame
(
	input CLOCK_50,
	input [3:0] KEY,
	input [9:0] SW,
	output logic [9:0] LEDR,
	output logic VGA_CLK,
	output logic VGA_BLANK_N,
	output logic VGA_SYNC_N,
	output logic VGA_HS,
	output logic VGA_VS,
	output logic [ 7:0] VGA_R,
	output logic [ 7:0] VGA_G,
	output logic [ 7:0] VGA_B,
	output     [6:0]  HEX5,HEX4,HEX1,HEX0	
);

	assign VGA_CLK = ~CLOCK_50;

	logic [10:0] xPos;			// current x position of hCount from the VGA controller
	logic [ 9:0] yPos;			// current y position of vCount from tge VGA controller
	logic [10:0] rightCollision;
	logic [9:0] topCollision;
	logic [9:0] bottomCollision;
	logic [3:0] paddleMove;
	logic drawBall;
	logic drawPaddle;

	
	//SignedDecoder Src    (Score2,HEX1,HEX0);
	//SignedDecoder Result (Score1,HEX5,HEX4);
	DecimalDisplayTwoDigit display1
	(	
		.Value(Score2),
		.Segments1(HEX1),
		.Segments0(HEX0)
	);
	DecimalDisplayTwoDigit display2
	( 
		.Value(Score1),
		.Segments1(HEX5),
		.Segments0(HEX4)
	);
	
	assign paddleMove = ~KEY;

	
	logic [10:0] rightCollision2;
	logic [9:0] topCollision2;
	logic [9:0] bottomCollision2;
	logic drawPaddle2;
	
	// instantiation of the VGA controller
	VgaController vgaDisplay
	(
		.Clock(CLOCK_50),
		.Reset(SW[9]),
		.blank_n(VGA_BLANK_N),
		.sync_n(VGA_SYNC_N),
		.hSync_n(VGA_HS),
		.vSync_n(VGA_VS),
		.nextX(xPos),
		.nextY(yPos)
	);
	

	
	// instatiation of the slowClock module
	slowClock #(17) tick(CLOCK_50, SW[9], pix_stb);
	
	
	// instantiation of the ball module
	// oLeft and oTop define the x,y initial position of the object
	
	paddle #(.oLeft(30), .oTop(225)) PaddleObj
	(
		.PixelClock(pix_stb),
		.Reset(SW[9]),
		.xPos(xPos),
		.yPos(yPos),
		.paddleMove(paddleMove[1:0]),
		.drawPaddle(drawPaddle),
		.rightCollision(rightCollision),
		.topCollision(topCollision),
		.bottomCollision(bottomCollision)
	);
	paddle #(.oLeft(720), .oTop(225)) PaddleObj2
	(
		.PixelClock(pix_stb),
		.Reset(SW[9]),
		.xPos(xPos),
		.yPos(yPos),
		.paddleMove(paddleMove[3:2]),
		.drawPaddle(drawPaddle2),
		.rightCollision(rightCollision2),
		.topCollision(topCollision2),
		.bottomCollision(bottomCollision2)
	);
	paddle #(.oLeft(395), .oTop(1), .oHeight(599) ,.oWidth(10)) LineObj
	(
		.PixelClock(pix_stb),
		.Reset(SW[9]),
		.xPos(xPos),
		.yPos(yPos),
		.drawPaddle(drawLine)
	);
	
	//assign LEDR = bottomCollision;
	
	ball #(.oLeft(390), .oTop(290)) BallObj
	(
		.PixelClock(pix_stb),
		.Reset(SW[9]),
		.xPos(xPos),
		.yPos(yPos),
		.rightCollision(rightCollision),
		.topCollision(topCollision),
		.bottomCollision(bottomCollision),
		.rightCollision2(rightCollision2),
		.topCollision2(topCollision2),
		.bottomCollision2(bottomCollision2),
		.drawBall(drawBall),
		.LocScore1(Score1),
		.LocScore2(Score2)
	);
	
	
	
	// this block is used to draw all the objects on the screen
	// you can add more objects and their corresponding colour
	always_comb
	begin
		if( drawBall )														// if true from the ball module
			{VGA_R, VGA_G, VGA_B} = {8'hFF, 8'hFF, 8'hFF};		// then draws the ball using white colour
		else if (drawPaddle)
			{VGA_R, VGA_G, VGA_B} = {8'hFF, 8'h00, 8'h00};
		else if (drawPaddle2)
			{VGA_R, VGA_G, VGA_B} = {8'h00, 8'h00, 8'hFF};
		else if (drawLine)
			{VGA_R, VGA_G, VGA_B} = {8'hFF, 8'hFF, 8'hFF};	
		else
			{VGA_R, VGA_G, VGA_B} = {8'h00, 8'h00, 8'h00};		// else draws the background using black colour
	end
	
endmodule
	
module DecimalDisplayTwoDigit 
#(
	parameter		ActiveValue = 0		// The output value that switches an LED on.
)
(
	input 	[6:0]	Value, 					// The input value in the decimal range 0-F
	output 	[6:0]	Segments1,Segments0  // The 7 bit outputs for the 7 segment displays.
);

	wire 	[6:0]	Digit [1:0];
	wire 			Blank [1:0];

	// Separate the digits
	assign Digit[0] = Value % 4'd10;
	assign Digit[1] = Value / 4'd10;

	// Set the blanking conditions
	assign Blank[0] = (Value > 7'd99) ? 1'b1 : 1'b0;
	assign Blank[1] = (Digit[1] == 7'd0) ? 1'b1 : Blank[0];

	// Instantiate the LED decoders
	SevenSegmentDecoder #(ActiveValue) decoder0 (Digit[0][6:0],Blank[0],Segments0);
	SevenSegmentDecoder #(ActiveValue) decoder1 (Digit[1][6:0],Blank[1],Segments1);

endmodule
	
	
module SevenSegmentDecoder 
#(
	parameter				ActiveValue = 0	// The output value that switches an LED on.
)
(
	input		[6:0] Value,						// The input value in the HEX range 0-F
	input 		 	Blank,						// An input which causes all LED outputs
														// to be off if this input is active (1)
	output 	[6:0] SegmentsOut					// The 7 bit output for the 7 segment display.
);

	logic  	[6:0] Segments;

	always @*
	begin
	   // Create the right bit sequence to drive the 7 segment 
		// display based upon the input value and whether or not
		// blanking is applied.
		case ({Blank,Value})
			0: 		Segments = 7'b0111111;
			1: 		Segments = 7'b0000110;
			2: 		Segments = 7'b1011011;
			3: 		Segments = 7'b1001111;
			4: 		Segments = 7'b1100110;
			5: 		Segments = 7'b1101101;
			6:			Segments = 7'b1111101;
			7: 		Segments = 7'b0000111;
			8: 		Segments = 7'b1111111;
			9: 		Segments = 7'b1101111;
			10: 		Segments = 7'b1110111;
			11: 		Segments = 7'b1111100;
			12: 		Segments = 7'b0111001;
			13: 		Segments = 7'b1011110;
			14: 		Segments = 7'b1111001;
			15: 		Segments = 7'b1110001;
			default:	Segments = 7'b0000000;
		endcase
	end

	// Invert the result if the output is active low.
	assign SegmentsOut = (ActiveValue == 1) ? Segments : ~Segments;
endmodule
	
	
	/*
	
	
	
	module SignedDecoder 
(
	input	  signed	[3:0] Value,
	output 	logic [6:0] Upper,
	output 	logic [6:0] Lower
);

	always_comb
	begin
		case (Value)
			-8: 		{Upper,Lower} = ~(14'b10000001111111);
			-7: 		{Upper,Lower} = ~(14'b10000000000111);
			-6: 		{Upper,Lower} = ~(14'b10000001111101);
			-5: 		{Upper,Lower} = ~(14'b10000001101101);
			-4: 		{Upper,Lower} = ~(14'b10000001100110);
			-3: 		{Upper,Lower} = ~(14'b10000001001111);
			-2: 		{Upper,Lower} = ~(14'b10000001011011);
			-1: 		{Upper,Lower} = ~(14'b10000000000110);
			 0: 		{Upper,Lower} = ~(14'b00000000111111);
			 1: 		{Upper,Lower} = ~(14'b00000000000110);
			 2: 		{Upper,Lower} = ~(14'b00000001011011);
			 3: 		{Upper,Lower} = ~(14'b00000001001111);
			 4: 		{Upper,Lower} = ~(14'b00000001100110);
			 5: 		{Upper,Lower} = ~(14'b00000001101101);
			 6:		{Upper,Lower} = ~(14'b00000001111101);
			 7: 		{Upper,Lower} = ~(14'b00000000000111);
			default:	{Upper,Lower} = ~(14'b00000000000000);
		endcase
	end
	
endmodule
*/