

module	boar_move	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input logic [4:0] speed,
					input	logic	gameOver,
					output	 logic signed	[10:0]	topLeftX  // can be negative , if the object is partliy outside 
					
);


// a module used to generate the  ball trajectory.  

const int SPEED_MULTIPLIER = 16;
const int	FIXED_POINT_MULTIPLIER	=	64; // note it must be 2^n 
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions


// movement limits 

const int	x_FRAME_LEFT		=	-512 * FIXED_POINT_MULTIPLIER;
const int	x_FRAME_RIGHT	=	1024 * FIXED_POINT_MULTIPLIER;

enum  logic [2:0] {IDLE_ST, // initial state
					MOVE_ST, // moving no colision 
					POSITION_CHANGE_ST,// position interpolate 
					POSITION_LIMITS_ST //check if inside the frame  
					}  SM_PS, 
						SM_NS ;

 int Xspeed_PS,  Xspeed_NS  ; 
 int Xposition_PS, Xposition_NS ;  


 //---------
 
 always_ff @(posedge clk or negedge resetN)
		begin : fsm_sync_proc
			if (resetN == 1'b0) begin 
				SM_PS <= IDLE_ST ; 
				Xspeed_PS <= 0  ; 
				Xposition_PS <= 0   ; 
			
			end 	
			else begin 
				SM_PS  <= SM_NS ;
				Xspeed_PS    <=   Xspeed_NS  ; 
				Xposition_PS <=  Xposition_NS    ; 
			end ; 
		end // end fsm_sync

 
 ///-----------------
 
 
always_comb 
begin
	// set default values 
		 SM_NS = SM_PS  ;
		 Xspeed_NS  = Xspeed_PS  ; 
		 Xposition_NS  = Xposition_PS  ; 
	 	

	case(SM_PS)
//------------
		IDLE_ST: begin
//------------
		 Xspeed_NS = speed * SPEED_MULTIPLIER;
		 if (startOfFrame) 
				SM_NS = MOVE_ST ;
 	
	end
	
//------------
		MOVE_ST:  begin     // moving no colision 
//------------
			Xspeed_NS = speed * SPEED_MULTIPLIER;
			
			if (gameOver) 
			begin
				SM_NS = IDLE_ST ;
				Xspeed_NS <= 0 ; 
				Xposition_NS <= 0 ; 
			end
			if (startOfFrame) 
						SM_NS = POSITION_CHANGE_ST ;
				
		end 
	

//------------------------
 		POSITION_CHANGE_ST : begin  // position interpolate 
//------------------------
	
			 Xposition_NS  = Xposition_PS + Xspeed_PS ;
	    
				SM_NS = POSITION_LIMITS_ST ; 
		end
		
		
//------------------------
		POSITION_LIMITS_ST : begin  //check if still inside the frame 
//------------------------
		
							
				if (Xposition_PS < x_FRAME_LEFT ) 
							Xposition_NS = x_FRAME_RIGHT; 
							
				 if (Xposition_PS > x_FRAME_RIGHT) 
							Xposition_NS = x_FRAME_LEFT; 

			SM_NS = MOVE_ST ; 
			
		end
		
endcase  // case 
end		
//return from FIXED point  trunc back to prame size parameters 
  
assign 	topLeftX = Xposition_PS / FIXED_POINT_MULTIPLIER;    

	

endmodule	
//---------------
 
