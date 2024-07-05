
module background_mux(	
					input	logic	resetN,
		  // trees
					     
					input		logic	tree_1_DrawingRequest, // two set of inputs per unit
					input		logic	[7:0] tree_1_RGB,     
					input		logic	tree_2_DrawingRequest, // two set of inputs per unit
					input		logic	[7:0] tree_2_RGB,
					input		logic	cactus_1_DrawingRequest, // two set of inputs per unit
					input		logic	[7:0] cactus_1_RGB,     
					input		logic	cactus_2_DrawingRequest, // two set of inputs per unit
					input		logic	[7:0] cactus_2_RGB,
			// houses
					     
					input		logic	house_1_DrawingRequest, // two set of inputs per unit
					input		logic	[7:0] house_1_RGB,     
					input		logic	house_2_DrawingRequest, // two set of inputs per unit
					input		logic	[7:0] house_2_RGB,
			// rocks
					     
					input		logic	rock_1_DrawingRequest, // two set of inputs per unit
					input		logic	[7:0] rock_1_RGB,     
					input		logic	rock_2_DrawingRequest, // two set of inputs per unit
					input		logic	[7:0] rock_2_RGB,	
			
		  // background 
					input		logic newLevel,
					output	logic	[7:0] RGBOut,
					output	logic	drawingRequest
);

always_comb 
begin
	RGBOut	= 8'b0;	
	drawingRequest = 1;
	if(!resetN) 
			RGBOut	= 8'b0;
	else if (tree_1_DrawingRequest && !newLevel)
		RGBOut = tree_1_RGB;
	else if (tree_2_DrawingRequest && !newLevel)
		RGBOut = tree_2_RGB;
	else if (house_1_DrawingRequest && !newLevel)
		RGBOut = house_1_RGB;
	else if (house_2_DrawingRequest && !newLevel)
		RGBOut = house_2_RGB;
	else if (cactus_1_DrawingRequest && newLevel)
		RGBOut = cactus_1_RGB;
	else if (cactus_2_DrawingRequest && newLevel)
		RGBOut = cactus_2_RGB;
	else if (rock_1_DrawingRequest && newLevel)
		RGBOut = rock_1_RGB;
	else if (rock_2_DrawingRequest && newLevel)
		RGBOut = rock_2_RGB;	
	else 	drawingRequest = 0;

end

endmodule


