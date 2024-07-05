
 module boarBitMap (

					input	logic	clk, 
					input	logic	resetN, 
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY, 
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
 ) ; 
 
 
// generating the bitmap 
 

localparam logic [7:0] TRANSPARENT_ENCODING = 8'h00 ;// RGB value in the bitmap representing a transparent pixel  
logic[0:31][0:63][7:0] object_colors = {
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hd5,8'hd5,8'hfe,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h6d,8'hff,8'hff,8'hff,8'hff,8'hd5,8'hd5,8'hd5,8'hfa,8'hd5,8'hb1,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff,8'hd6,8'hd5,8'hd5,8'hd5,8'hd6,8'hd6,8'hd5,8'hd5,8'h24,8'h24,8'hd5,8'hfa,8'hfa,8'hfa,8'hd5,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hff,8'hff,8'hd5,8'hfa,8'hfe,8'hfe,8'hd5,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hd5,8'hff,8'hff,8'hd5,8'hd5,8'hfe,8'hfe,8'hfa,8'hd5,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd5,8'hb1,8'had,8'hff,8'hd5,8'hfa,8'hfe,8'hfe,8'hfe,8'hd5,8'hd5,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hd5,8'hd5,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hb1,8'hb1,8'hff,8'hd5,8'hd5,8'hd5,8'hfe,8'hfe,8'hfe,8'hfe,8'hff,8'hd5,8'hd5,8'hd5,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hd5,8'hd5,8'hd5,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hf6,8'hd5,8'h24,8'hd5,8'hd5,8'hfe,8'hfe,8'hfe,8'hfe,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hd5,8'hd5,8'hd5,8'hfa,8'hfa,8'hd5,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hd5,8'had,8'hb1,8'hff,8'hff,8'hd5,8'hfe,8'hd5,8'hd5,8'hd5,8'hd5,8'hff,8'hff,8'hff,8'hd5,8'hd5,8'hd5,8'hff,8'hff,8'hff,8'h24,8'h6d,8'hff,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hd5,8'hd5,8'hd5,8'hfa,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hd5,8'hb1,8'hb1,8'h64,8'h64,8'hd5,8'hfe,8'hd5,8'hd5,8'hd5,8'hd5,8'hff,8'hff,8'hff,8'hd5,8'hd5,8'hd5,8'hff,8'hff,8'h6c,8'hff,8'hff,8'h20,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hfa,8'hd5,8'hd5,8'hfa,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hd5,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hb1,8'hb1,8'hb1,8'hff,8'hd5,8'hd5,8'hd5,8'hd5,8'hff,8'h34,8'h34,8'h00,8'hff,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hfa,8'hff,8'hf6,8'hff,8'hff,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hfa,8'hfa,8'hfa,8'hfa,8'hd5,8'hd5,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hff,8'h0c,8'h0c,8'h34,8'hff,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hff,8'hee,8'hf6,8'hf6,8'hff},
	{8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hd5,8'hd5,8'hd5,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hd5,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hf5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hff,8'hff,8'hff,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hff,8'hee,8'hf6,8'hf6,8'hff},
	{8'hff,8'hd5,8'hd5,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hd5,8'hd5,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd5,8'hf5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hff,8'hff,8'hff,8'had,8'hff,8'hee,8'hee,8'hff},
	{8'hff,8'hd5,8'hd5,8'hff,8'hff,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hfa,8'hfa,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hff,8'hfe,8'hff,8'hff,8'had,8'hff,8'hee,8'hee,8'hff},
	{8'hff,8'hb1,8'hb1,8'hd5,8'hd5,8'hff,8'hff,8'hff,8'hd5,8'hb1,8'hb1,8'had,8'hff,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hf5,8'hd5,8'hff,8'hff,8'h00,8'hfe,8'hff,8'hff,8'had,8'hb1,8'hff,8'hff,8'hff},
	{8'hff,8'hb1,8'hb1,8'hd5,8'hd5,8'hff,8'hff,8'hff,8'hd5,8'hb1,8'hb1,8'hb1,8'hff,8'hd5,8'hd5,8'hd5,8'hd5,8'hd1,8'hd1,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hff,8'hff,8'hfe,8'hfe,8'hff,8'hff,8'had,8'had,8'hff,8'hff,8'hff},
	{8'h00,8'hff,8'hff,8'hff,8'had,8'had,8'had,8'had,8'had,8'hff,8'hff,8'hff,8'hff,8'had,8'had,8'hd5,8'hd5,8'hfa,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hff,8'hd6,8'hd6,8'hfe,8'hd6,8'hff,8'hff,8'had,8'had,8'had,8'had,8'hff},
	{8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'hff,8'had,8'had,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hff,8'hff,8'hd6,8'hff,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'had,8'had,8'hd5,8'hd5,8'hd5,8'hd5,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hfa,8'hfa,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hb1,8'had,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'had,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hf5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hfa,8'hfa,8'hfa,8'hd5,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'had,8'had,8'had,8'had,8'hb1,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'had,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hfa,8'hfa,8'hfa,8'hd5,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'had,8'had,8'hb1,8'had,8'had,8'had,8'had,8'had,8'hb1,8'had,8'had,8'hff,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'had,8'had,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hff,8'had,8'had,8'had,8'had,8'had,8'had,8'had,8'hd5,8'h64,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hb1,8'had,8'hd5,8'hd5,8'hd5,8'hf5,8'hfa,8'hd5,8'hd5,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd1,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hff,8'hb1,8'had,8'had,8'had,8'had,8'had,8'had,8'had,8'h24,8'h24,8'hff,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'had,8'had,8'hb1,8'hd5,8'hd5,8'hff,8'h24,8'had,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hfa,8'hfa,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hff,8'hb1,8'hb1,8'hb1,8'hb1,8'hb1,8'hb1,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'had,8'had,8'hd5,8'hd5,8'hd5,8'hd5,8'hff,8'hff,8'hd5,8'hb1,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hfa,8'hd5,8'hd5,8'hd5,8'had,8'had,8'hd5,8'hd5,8'hd5,8'hd5,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'had,8'had,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hff,8'had,8'hb1,8'had,8'hb1,8'had,8'had,8'had,8'had,8'had,8'hb1,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'hd5,8'had,8'hd5,8'hb1,8'hb1,8'had,8'hff,8'had,8'had,8'hb1,8'hd5,8'hd5,8'hd5,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'had,8'had,8'had,8'had,8'had,8'had,8'hff,8'hff,8'hff,8'h00,8'hff,8'hff,8'had,8'hb1,8'hb1,8'had,8'had,8'had,8'had,8'had,8'had,8'had,8'had,8'had,8'had,8'had,8'had,8'had,8'had,8'had,8'had,8'had,8'had,8'had,8'hff,8'hff,8'had,8'had,8'hd5,8'hd5,8'hd5,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'had,8'had,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hb1,8'hb1,8'had,8'had,8'had,8'had,8'had,8'had,8'had,8'had,8'had,8'had,8'had,8'had,8'had,8'had,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'hff,8'hff,8'hb1,8'had,8'had,8'hd5,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'h91,8'h91,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'h91,8'h91,8'hb1,8'h91,8'h91,8'h91,8'h91,8'h91,8'h91,8'h91,8'h8d,8'hb1,8'h91,8'h91,8'h91,8'h91,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'hff,8'hff,8'h8d,8'h91,8'hb1,8'hd5,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h24,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00}};

 
 	 
//////////--------------------------------------------------------------------------------------------------------------= 
always_ff@(posedge clk or negedge resetN) 
begin 
	if(!resetN) 
		RGBout <=	8'h00; 
	else begin 
		RGBout <= TRANSPARENT_ENCODING ; // default  
 
		if (InsideRectangle == 1'b1) 
			RGBout <= object_colors[offsetY][offsetX]; 		 
	end 
end 
 
//////////--------------------------------------------------------------------------------------------------------------= 
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   
 
endmodule 
