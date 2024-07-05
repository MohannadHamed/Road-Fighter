
module	back_ground_draw	(	

					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] pixelX,
					input logic	[10:0] pixelY,
					input	logic	newLevel,
					output logic [7:0] BG_RGB,
					output logic boardersDrawReq 
);

const int	rightBackGroundEnd = 480;
const int	xFrameSize = 640;
const int	yFrameSize = 480;
logic [2:0] redBits;
logic [2:0] greenBits;
logic [1:0] blueBits;
logic [10:0] shift_pixelX;

localparam logic [2:0] DARK_COLOR = 3'b111 ;// bitmap of a dark color
localparam logic [2:0] LIGHT_COLOR = 3'b000 ;// bitmap of a light color   	
 
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
				redBits <= DARK_COLOR ;	
				greenBits <= DARK_COLOR  ;	
				blueBits <= DARK_COLOR ;	 
	end 
	else begin
	// defaults 
		greenBits <= DARK_COLOR ; 
		redBits <= DARK_COLOR ;
		blueBits <= 2'b11;//LIGHT_COLOR;
		boardersDrawReq <= 	1'b0 ; 
		
		if ((pixelX <= rightBackGroundEnd) && (pixelY < yFrameSize))
			if (newLevel == 0)
				begin 
					redBits <= LIGHT_COLOR ;	
					greenBits <= DARK_COLOR  ;	
					blueBits <= LIGHT_COLOR;
					boardersDrawReq <= 	1'b1;
				end
			else
				begin 
					redBits <= DARK_COLOR ;	
					greenBits <= 3'b101  ;	
					blueBits <= 2'b01;
					boardersDrawReq <= 	1'b1;
				end
		else
			begin 
					redBits <= LIGHT_COLOR ;	
					greenBits <= LIGHT_COLOR  ;	
					blueBits <= LIGHT_COLOR;
					boardersDrawReq <= 	1'b1;
			end				
		
	BG_RGB =  {redBits , greenBits , blueBits} ; //collect color nibbles to an 8 bit word 
			


	end; 	
end 
endmodule

