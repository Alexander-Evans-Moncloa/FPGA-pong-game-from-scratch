///////////////////////////////////////////////////////////////
// Authors: ANONYMOUS and Alexander Evans Moncloa
// Date: 13/12/2022
// Module name: paddle
// Description: All 3 paddles in pong (middle white line is seen as a paddle too)
///////////////////////////////////////////////////////////////

module paddle
#(								// default values
	oLeft = 10,				// x position of the paddle
	oTop = 10,				// y position of the paddle
	oHeight = 150,			// height of the paddle
	oWidth = 50,			// width of the paddle
	sWidth = 800,			// width of the screen
	sHeight = 600,			// height of the screen
	yDirMove = 0			// paddle movement in y direction
)
(
	input PixelClock,					// slow clock to display pixels
	input Reset,						// reset position/movement of the ball
	input  logic [10:0] xPos,		// x position of hCounter
	input  logic [ 9:0] yPos,		// y position of vCounter
	input logic [1:0]paddleMove,
	output logic drawPaddle,			// activates/deactivates drawing
	output logic [10:0] rightCollision,
	output logic [9:0] topCollision,
	output logic [9:0] bottomCollision
);

	logic [10:0] left;
	logic [10:0] right;						
	logic [10:0] top;
	logic [10:0] bottom;
	logic [10:0] paddleX = oLeft;
	logic [10:0] paddleY = oTop;
	
	logic ydir = yDirMove;	
		
	assign left = paddleX;						// left(x) position of the ball
	assign right = paddleX + oWidth;		// right(x+width) position of the ball
	assign top = paddleY;						// top(y) position of the ball
	assign bottom = paddleY + oHeight;		// bottom(y+height) position of the ball
	
		
	always_ff @(posedge PixelClock)
	begin
		if( Reset == 1 )						// all values are initialised
			begin									// whenever the reset(SW[9]) is 1
				paddleX <= oLeft;
				paddleY <= oTop;
				ydir <= yDirMove;
			end
		else
			begin
				//ballX <= (xdir == 1) ? ballX + 1 : ballX - 1;	// changes movement of the ball in x direction
				if(paddleMove[0]==1)paddleY <=paddleY- 1;
				if(paddleMove[1]==1)paddleY <=paddleY+ 1;
				//paddleY <= (paddleMove[1]==1) ? paddleY - 1 : paddleY +0;
				//paddleY <= (paddleMove[2]==1) ? paddleY + 1 : paddleY +0;	// changes movement of the ball in y direction
				// these lines determine the direction of movement
				// based on the correct position of the ball wrt the screen
				if( top  <= 0 )
					paddleY <= 1;

				if( bottom >= sHeight )
					paddleY <= sHeight-oHeight-1;

			end
	end


	// drawBall is 1 if the screen counters (hCount and vCount) are in the area of the ball
	// otherwise, drawBall is 0 and the ball is not drawn.
	// drawBall is used by the top module PongGame
	assign drawPaddle = ((xPos > left) & (yPos > top) & (xPos < right) & (yPos < bottom)) ? 1 : 0;
	assign rightCollision = paddleX + oWidth;
	assign topCollision = paddleY;
	assign bottomCollision = paddleY + oHeight;
endmodule