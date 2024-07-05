module	boar_object	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic signed	[10:0] pixelX,
					input 	logic signed	[10:0] pixelY,
					input 	logic signed	[10:0] topLeftX, 
					input 	logic	signed [10:0] topLeftY,
					output 	logic	[10:0] offsetX,
					output 	logic	[10:0] offsetY,
					output 	logic	drawingRequest
);

parameter  int OBJECT_WIDTH_X = 64;
parameter  int OBJECT_HEIGHT_Y = 32;
int rightX ; //coordinates of the sides  
int bottomY ;
logic insideBracket ; 
//////////--------------------------------------------------------------------------------------------------------------=
// Calculate object right  & bottom  boundaries
assign rightX	= (topLeftX + OBJECT_WIDTH_X);
assign bottomY	= (topLeftY + OBJECT_HEIGHT_Y);
assign	insideBracket  = 	 ( (pixelX  >= topLeftX) &&  (pixelX < rightX) 
						   && (pixelY  >= topLeftY) &&  (pixelY < bottomY))  ; 
//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		drawingRequest	<=	1'b0;

	end
	else begin 
		// DEFUALT outputs
			drawingRequest <= 1'b0 ;
			offsetX	<= 0; //no offset
			offsetY	<= 0; //no offset
		if (insideBracket ) // test if it is inside the rectangle 
		begin 
			if (pixelX > 480)begin
				offsetX	<= 0; //calculate relative offsets from top left corner allways a positive number
				offsetY	<= 0;
			end
			else begin
				offsetX	<= (pixelX - topLeftX); //calculate relative offsets from top left corner allways a positive number
				offsetY	<= (pixelY - topLeftY);
				drawingRequest <= 1'b1 ;
			end

		end 
		
	end
end 
endmodule 