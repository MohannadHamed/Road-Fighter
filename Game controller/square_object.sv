module	square_object	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic signed	[10:0] pixelX,
					input 	logic signed	[10:0] pixelY,
					input 	logic signed	[10:0] topLeftX, 
					input 	logic	signed [10:0] topLeftY,
					input		logic collision,
					input		logic newLevel,
					input		logic heart,
					input		logic tree,
					input    logic score,
					input    logic fuel,
					input    logic	 [3:0] heartControl, 
					input    logic Time,
					output 	logic	[10:0] offsetX,
					output 	logic	[10:0] offsetY,
					output 	logic	drawingRequest,
					output 	logic	drawingRequest2,
					output 	logic	drawingRequest3,
					output 	logic	drawingRequest4,
					output 	logic	drawingRequest5,
					output 	logic	drawingRequest6
);

parameter  int OBJECT_WIDTH_X = 16;
parameter  int OBJECT_HEIGHT_Y = 16;
int rightX ; //coordinates of the sides  
int bottomY ;
logic insideBracket ; 
//////////--------------------------------------------------------------------------------------------------------------=
// Calculate object right  & bottom  boundaries
assign rightX	= (heart == 0) ? (topLeftX + OBJECT_WIDTH_X) : (topLeftX + (OBJECT_WIDTH_X*heartControl));
assign bottomY	= (tree == 0) ? (topLeftY + OBJECT_HEIGHT_Y) : (topLeftY + OBJECT_HEIGHT_Y + 128);
assign	insideBracket  = 	 ( (pixelX  >= topLeftX) &&  (pixelX < rightX) 
						   && (pixelY  >= topLeftY) &&  (pixelY < bottomY))  ; 
assign	insideBracketdigit2  = 	 ( (pixelX  >= topLeftX + OBJECT_WIDTH_X) &&  (pixelX < rightX + OBJECT_WIDTH_X)   
						   && (pixelY  >= topLeftY) &&  (pixelY < bottomY))	;
assign	insideBracketdigit3  = 	 ( (pixelX  >= topLeftX + 2*OBJECT_WIDTH_X) &&  (pixelX < rightX + 2*OBJECT_WIDTH_X)  
						   && (pixelY  >= topLeftY) &&  (pixelY < bottomY))	;
assign	insideBracketdigit4  = 	 ( (pixelX  >= topLeftX + 3*OBJECT_WIDTH_X) &&  (pixelX < rightX + 3*OBJECT_WIDTH_X)  
						   && (pixelY  >= topLeftY) &&  (pixelY < bottomY))	;
assign	insideBracketdigit5  = 	 ( (pixelX  >= topLeftX + 4*OBJECT_WIDTH_X) &&  (pixelX < rightX + 4*OBJECT_WIDTH_X)   
						   && (pixelY  >= topLeftY) &&  (pixelY < bottomY))	;
assign	insideBracketdigit6  = 	 ( (pixelX  >= topLeftX + 5*OBJECT_WIDTH_X) &&  (pixelX < rightX + 5*OBJECT_WIDTH_X)  
						   && (pixelY  >= topLeftY) &&  (pixelY < bottomY))	;
assign	insideScoreBracket  = 	 ( (pixelX  >= topLeftX) &&  (pixelX < rightX + 5*OBJECT_WIDTH_X)   
						   && (pixelY  >= topLeftY) &&  (pixelY < bottomY))  ; 
assign	insideTimeBracket  = 	 ( (pixelX  >= topLeftX) &&  (pixelX < rightX+ 4*OBJECT_WIDTH_X) 
						   && (pixelY  >= topLeftY) &&  (pixelY < bottomY))  ; 
//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		drawingRequest	<=	1'b0;
		drawingRequest2	<=	1'b0;
		drawingRequest3	<=	1'b0;
		drawingRequest4	<=	1'b0;
		drawingRequest5	<=	1'b0;
		drawingRequest6	<=	1'b0;

	end
	else begin 
		// DEFUALT outputs
			drawingRequest <= 1'b0 ;
			drawingRequest2	<=	1'b0;
			drawingRequest3	<=	1'b0;
			drawingRequest4	<=	1'b0;
			drawingRequest5	<=	1'b0;
			drawingRequest6	<=	1'b0;
			offsetX	<= 0; //no offset
			offsetY	<= 0; //no offset
		if ((insideBracket && tree == 0) ||  (insideBracket && pixelY  >= (topLeftY +128)) || 
				(score && (insideScoreBracket || insideBracketdigit4 || insideBracketdigit5 || insideBracketdigit6)) || 
				((fuel || score || Time) && (insideBracketdigit2 || insideBracketdigit3)) ||
				(Time && (insideTimeBracket || insideBracketdigit4 || insideBracketdigit5))) // test if it is inside the rectangle 
		begin 
			offsetX	<= (pixelX - topLeftX); //calculate relative offsets from top left corner allways a positive number
			if (tree == 0)
				offsetY	<= (pixelY - topLeftY);
			else
				offsetY	<= (pixelY - topLeftY - 128);
			if (insideBracket)
				drawingRequest <= 1'b1 ;
			if (insideBracketdigit2 && (fuel || score || Time))
				drawingRequest2 <= 1'b1 ;
			if (insideBracketdigit3 && (fuel || score || Time))
				drawingRequest3 <= 1'b1 ;
			if (insideBracketdigit4 && (score || Time))
				drawingRequest4 <= 1'b1 ;
			if (insideBracketdigit5 && (score || Time))
				drawingRequest5 <= 1'b1 ;
			if (insideBracketdigit6 && score)
				drawingRequest6 <= 1'b1 ;
		end 
		
	end
end 
endmodule 