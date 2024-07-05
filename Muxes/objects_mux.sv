
module	objects_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
		   // player 
					input		logic	playerDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] playerRGB,	
			//road     
					input		logic	roadDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] roadRGB, 
			// background 
					input    logic [7:0] background_RGB,
					input		logic	backgroundObjects_DrawingRequest, // two set of inputs per unit
					input		logic	[7:0] backgroundObjects_RGB,	
					input		logic enterFirstPress,
					input		logic	roadFighter_DrawingRequest, // two set of inputs per unit
					input		logic	[7:0] roadFighter_RGB,
					input		logic	enter_DrawingRequest, // two set of inputs per unit
					input		logic	[7:0] enter_RGB,
					input		logic	introPic_DrawingRequest, // two set of inputs per unit
					input		logic	[7:0] introPic_RGB,
					input		logic	gameOver_DrawingRequest, // two set of inputs per unit
					input		logic	[7:0] gameOver_RGB,
					input		logic	boar_DrawingRequest, // two set of inputs per unit
					input		logic	[7:0] boar_RGB,
					input		logic	data_DrawingRequest, // two set of inputs per unit
					input		logic	[7:0] data_RGB,
				   output	logic	[7:0] RGBOut,
					output logic game_running

);
logic enterPressed = 0;
logic gameOver = 0;

assign game_running = enterPressed;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBOut	<= 8'b0;
			enterPressed <= 1'b0;
			gameOver <= 0;
	end
	else if (introPic_DrawingRequest && !enterPressed && !gameOver)
			RGBOut <= introPic_RGB;
	else if (roadFighter_DrawingRequest && !enterPressed && !gameOver)
			RGBOut <= roadFighter_RGB;
	else if (enter_DrawingRequest && !enterPressed)
			RGBOut <= enter_RGB;	
	else if (gameOver_DrawingRequest)
	begin
			RGBOut <= gameOver_RGB;
			gameOver <= 1'b1;
			enterPressed <= 1'b0;
	end
	else if (enterFirstPress || enterPressed)
	begin
		gameOver <= 1'b0;
		enterPressed <= 1'b1;
		if (playerDrawingRequest == 1'b1 )   
			RGBOut <= playerRGB;
		else if (data_DrawingRequest== 1'b1)
			RGBOut <= data_RGB;		
		else if (boar_DrawingRequest)
			RGBOut <= boar_RGB;		
		else if (roadDrawingRequest== 1'b1)
			RGBOut <= roadRGB;
		else if (backgroundObjects_DrawingRequest== 1'b1)
			RGBOut <= backgroundObjects_RGB;		
		else RGBOut <= background_RGB ;// last priority 
	end 
	else 	RGBOut <= 8'b0;
end
endmodule


