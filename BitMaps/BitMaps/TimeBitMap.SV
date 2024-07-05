
 module TimeBitMap (

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
logic[0:15][0:63][7:0] object_colors = {
	{8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00}};

 
  
//////////--------------------------------------------------------------------------------------------------------------= 
always_ff@(posedge clk or negedge resetN) 
begin 
	if(!resetN) 
		RGBout <=	8'h00; 
	else begin 
		RGBout <= TRANSPARENT_ENCODING ; // default  
		if (InsideRectangle == 1'b1 ) 
			RGBout <= object_colors[offsetY][offsetX]; 		 
	end 
end 
 
//////////--------------------------------------------------------------------------------------------------------------= 
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   
 
endmodule 
