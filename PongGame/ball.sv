///////////////////////////////////////////////////////////////
// Authors: ANONYMOUS and Alexander Evans Moncloa
// Date: 13/12/2022
// Module name: ball
// Description: The ball in the pong game. This also increments the scores for player 1 and 2.
///////////////////////////////////////////////////////////////


module ball
#(								// default values
	oLeft = 10,				// x position of the ball
	oTop = 10,				// y position of the ball
	oHeight = 20,			// height of the ball
	oWidth = 20,			// width of the ball
	sWidth = 800,			// width of the screen
	sHeight = 600,			// height of the screen
	xDirMove = 1,			// ball movement in x direction
	yDirMove = 1			// ball movement in y direction
)
(
	input PixelClock,					// slow clock to display pixels
	input Reset,						// reset position/movement of the ball
	input  logic [10:0] xPos,		// x position of hCounter
	input  logic [ 9:0] yPos,		// y position of vCounter
	input logic [10:0] rightCollision,
	input logic [9:0] topCollision,
	input logic [9:0] bottomCollision,
	input logic [10:0] rightCollision2,
	input logic [9:0] topCollision2,
	input logic [9:0] bottomCollision2,
	output logic drawBall,	// activates/deactivates drawing
	output logic [3:0] LocScore1,
	output logic [3:0] LocScore2
	
);
	

	logic [10:0] left;						
	logic [10:0] right;						
	logic [10:0] top;
	logic [10:0] bottom;
	logic   scorecollision1;
	logic   scorecollision2;
	//logic LocScore1;
	//logic LocScore2;
	
	logic [10:0] ballX = oLeft;
	logic [10:0] ballY = oTop;

	logic xdir = xDirMove;
	logic ydir = yDirMove;	


	assign left = ballX;						// left(x) position of the ball
	assign right = ballX + oWidth;		// right(x+width) position of the ball
	assign top = ballY;						// top(y) position of the ball
	assign bottom = ballY + oHeight;		// bottom(y+height) position of the ball
	//assign Score1 = Score1 + scorecollision1;
	//assign Score2 = scorecollision2 == 1 ? Score2 + 1:Score2;
	assign LocScore1 = (scorecollision1 == 1) ? LocScore1 + 1 : LocScore1 + 0;
	assign LocScore2 = (scorecollision2 == 1) ? LocScore2 + 1 : LocScore2 + 0;
		
	always_ff @(posedge PixelClock)
	begin
		if( Reset == 1 )						// all values are initialised
			begin									// whenever the reset(SW[9]) is 1
				ballX <= oLeft;
				ballY <= oTop;
				xdir <= xDirMove;
				ydir <= yDirMove;
				//LocScore1 <= 0;
				//LocScore2 <= 0;
			end
		else
			begin
				ballX <= (xdir == 1) ? ballX + 1 : ballX - 1;	// changes movement of the ball in x direction
				ballY <= (ydir == 1) ? ballY + 1 : ballY - 1;	// changes movement of the ball in y direction
				//LocScore1 <= (scorecollision1 == 1) ? LocScore1 + 1 : LocScore1 + 0;
				//LocScore2 <= (scorecollision2 == 1) ? LocScore2 + 1 : LocScore2 + 0;
				// these lines determine the direction of movement
				// based on the correct position of the ball wrt the screen
				if( top  <= 1 )
					ydir <= 1;

				if( bottom >= sHeight )
					ydir <= 0;

				if( left <= 1 )
					begin
					xdir <= 1;
					ballX <= oLeft;
					ballY <= oTop;
					scorecollision1 <=1;
					end
				else scorecollision1 <=0;
					
				if( right >= sWidth )
					begin
					xdir <= 0;
					ballX <= oLeft;
					ballY <= oTop;
					scorecollision2 <=1;
					end
				else scorecollision2 <=0;
					
				if( left <= rightCollision & left >= rightCollision -2 &bottom >= topCollision &  top <= bottomCollision )
					xdir <= 1;	
				else if( left <= rightCollision & (bottom >= topCollision & bottom <= bottomCollision))
					ydir <= 0;	
				else if( left <= rightCollision &  (top <= bottomCollision & top >= topCollision))
					ydir <= 1;	
				else if( right >= rightCollision2-50 & right <= rightCollision2-48 &bottom >= topCollision2 &  top <= bottomCollision2 )
					xdir <= 0;	
				else if( right >= rightCollision2-50 & (bottom >= topCollision2 & bottom <= bottomCollision2))
					ydir <= 0;	
				else if( right >= rightCollision2-50 &  (top <= bottomCollision2 & top >= topCollision2))
					ydir <= 1;
					//
			end
	end
	
	/*	always_comb
	begin
	
	if ( scorecollision1 )
		begin
		Score1 = Score1 + 1;
		scorecollision1 = 0;
		end

	if ( scorecollision2 )
		begin
		Score2 = Score2 + 1;
		scorecollision2 = 0;
		end
		
	end*/

	// drawBall is 1 if the screen counters (hCount and vCount) are in the area of the ball
	// otherwise, drawBall is 0 and the ball is not drawn.
	// drawBall is used by the top module PongGame
	assign drawBall = ((xPos > left) & (yPos > top) & (xPos < right) & (yPos < bottom)) ? 1 : 0;
	
	
endmodule
