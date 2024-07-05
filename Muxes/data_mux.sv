
module	data_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
			// words
					input		logic	score_DrawingRequest, 
					input		logic	[7:0] score_RGB,		
					input		logic	fuel_DrawingRequest, 
					input		logic	[7:0] fuel_RGB,
					input		logic	health_DrawingRequest, 
					input		logic	[7:0] health_RGB,
					input		logic	heart_DrawingRequest, 
					input		logic	[7:0] heart_RGB,
		  // digits
					input		logic	scoreDigit_DrawingRequest, 
					input		logic	[7:0] scoreDigit_RGB,
					input		logic	fuelDigit_DrawingRequest,
					input		logic	[7:0] fuelDigit_RGB,
					input		logic	time_DrawingRequest, 
					input		logic	[7:0] time_RGB,					
					input		logic	timeDigits_DrawingRequest, 
					input		logic	[7:0] timeDigits_RGB,
				   output	logic	[7:0] RGBOut,
					output	logic	drawingRequest
);

always_comb
begin
	RGBOut	= 8'b0;	
	drawingRequest = 1;
	if(!resetN) 
			RGBOut	= 8'b0;
	else if (score_DrawingRequest)
		RGBOut = score_RGB;
	else if (fuel_DrawingRequest)
		RGBOut = fuel_RGB;
	else if (health_DrawingRequest)
		RGBOut = health_RGB;
	else if (heart_DrawingRequest)
		RGBOut = heart_RGB;
	else if (scoreDigit_DrawingRequest)
		RGBOut = scoreDigit_RGB;
	else if (fuelDigit_DrawingRequest)
		RGBOut = fuelDigit_RGB;
	else if (time_DrawingRequest)
		RGBOut = time_RGB;
	else if (timeDigits_DrawingRequest)
		RGBOut = timeDigits_RGB;
	else drawingRequest = 0;
end

endmodule


