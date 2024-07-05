
module	obstacle_move	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input	logic	createObject,
					input logic [4:0] speed,
					input	logic [10:0] objectX,
					input	logic	gameOver,
					output	 logic signed	[10:0]	topLeftX,
					output	 logic signed	[10:0]	topLeftY,  // can be negative , if the object is partliy outside 
					output logic object_ready
);


// a module used to generate the  ball trajectory.  

localparam int INITIAL_Y = -OBJECT_HIGHT_Y;
parameter object_speed = 2;

localparam MAX_Y = 480;

const int SPEED_MULTIPLIER = 16;
const int	FIXED_POINT_MULTIPLIER	=	64; // note it must be 2^n 
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions


// movement limits 
const int   OBJECT_WIDTH_X = 64;
localparam int   OBJECT_HIGHT_Y = 128;







logic [4:0] Yspeed;
assign Yspeed = speed - object_speed;

enum  logic [2:0] {IDLE_ST, // initial state
					MOVE_ST, // moving no colision 
					POSITION_CHANGE_ST,// position interpolate 
					POSITION_LIMITS_ST //check if inside the frame  
					}  SM_PS, 
						SM_NS ;

 int Yspeed_PS,  Yspeed_NS  ; 
 int Yposition_PS, Yposition_NS ;  
 int Xposition_PS, Xposition_NS ;  


 //---------
 
 always_ff @(posedge clk or negedge resetN)
		begin : fsm_sync_proc
			if (resetN == 1'b0) begin 
				SM_PS <= IDLE_ST ; 
				Yspeed_PS <= 0  ; 
				Yposition_PS <= 0   ; 
			
			end 	
			else begin 
				SM_PS  <= SM_NS ;
				Yspeed_PS    <=   Yspeed_NS  ; 
				Yposition_PS <=  Yposition_NS    ; 
				Xposition_PS <=  Xposition_NS    ; 
			end ; 
		end // end fsm_sync

 
 ///-----------------
 
 
always_comb 
begin
	// set default values 
		 SM_NS = SM_PS  ;
		 Yspeed_NS  = Yspeed_PS  ; 
		 Yposition_NS  = Yposition_PS  ; 
	 	 Xposition_NS  = Xposition_PS  ; 
		 object_ready = 1'b0;

	case(SM_PS)
//------------
		IDLE_ST: begin
//------------
//		 Yspeed_NS = Yspeed * SPEED_MULTIPLIER;
		 Yspeed_NS = speed * SPEED_MULTIPLIER;
		 Yposition_NS = INITIAL_Y * FIXED_POINT_MULTIPLIER; 
		 Xposition_NS = objectX ; 
		 object_ready = 1'b1;

		 if (createObject) 
				SM_NS = MOVE_ST ;
 	
	end
	
//------------
		MOVE_ST:  begin     // moving no colision 
//------------
//			Yspeed_NS = Yspeed * SPEED_MULTIPLIER;
			Yspeed_NS = Yspeed * SPEED_MULTIPLIER;
			if(gameOver) begin 
				SM_NS = IDLE_ST ; 
			end 
			else if (startOfFrame) 
						SM_NS = POSITION_CHANGE_ST ;
				
		end 
	

//------------------------
 		POSITION_CHANGE_ST : begin  // position interpolate 
//------------------------
	
			 Yposition_NS  = Yposition_PS + Yspeed_PS ;
	    
			 SM_NS = POSITION_LIMITS_ST ; 
		end
		
		

//------------------------
 		POSITION_LIMITS_ST : begin  // position interpolate 
//------------------------
	
			if(topLeftY >= MAX_Y)
				SM_NS = IDLE_ST;
			else
				SM_NS = MOVE_ST ; 
		end
endcase  // case 
end		
//return from FIXED point  trunc back to prame size parameters 
  
assign 	topLeftY = Yposition_PS / FIXED_POINT_MULTIPLIER ;    
assign 	topLeftX = Xposition_PS;    
	

endmodule	
//---------------
 
