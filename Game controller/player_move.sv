
module	player_move	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input logic [1:0]Road_Edge_Collision,//1 for right, 2 for left, 0 for none
					input logic [2:0]level,
					input logic up_key,
					input logic down_key,
					input logic x_key_right,
					input logic x_key_left,
					input logic [3:0] oil_hit,
					input logic gameOver,
					output logic hit_edge,
					output	 logic signed 	[10:0]	topLeftX, // output the top left corner 
					output	 logic signed	[10:0]	topLeftY,  // can be negative , if the object is partliy outside 
					output	 logic [7:0] car_speed

					
					
);


// a module used to generate the  ball trajectory.

logic [0:7][7:0] speeds_level= //matrix of all initial speeds by level
{8'h50, 8'h50, 8'h50, 8'h60, 8'h80, 8'hA0, 8'hB0, 8'hB5};
logic [7:0] current_speed;
assign current_speed = speeds_level[level][7:0] - oil_slowing;

localparam oil_slowing_param = 25;
logic [5:0] oil_slowing;

parameter int INITIAL_X = 280;
parameter int INITIAL_Y = 100;
parameter int INITIAL_X_SPEED = 0;
parameter int Y_SPEED_INNER = 40;

localparam LOWEST_Y = 400 * 64;
localparam HIGHEST_Y = 250 * 64;

localparam bump_on_collision = 2 *64;





const int	FIXED_POINT_MULTIPLIER	=	64; // note it must be 2^n 
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions


// movement limits 
const int   OBJECT_WIDTH_X = 64;
const int   OBJECT_HIGHT_Y = 64;
const int	SafetyMargin =	2;



const int	x_FRAME_LEFT	=	(SafetyMargin)* FIXED_POINT_MULTIPLIER; 
const int	x_FRAME_RIGHT	=	(639 - SafetyMargin - OBJECT_WIDTH_X)* FIXED_POINT_MULTIPLIER; 

enum  logic [2:0] {IDLE_ST, // initial state
					MOVE_ST, // moving no colision 
					WAIT_FOR_EOF_ST, // change speed done, wait for startOfFrame  
					POSITION_CHANGE_ST,// position interpolate 
					POSITION_LIMITS_ST //check if inside the frame  
					}  SM_PS, 
						SM_NS ;

 int Xspeed_PS,  Xspeed_NS  ; // speed    
 int Xposition_PS, Xposition_NS ; //position   
 int Yposition_PS, Yposition_NS ; //position   
 int Yspeed_PS,  Yspeed_NS  ;
 

 logic x_key;

 //---------
 
 always_ff @(posedge clk or negedge resetN)
		begin : fsm_sync_proc
			if (resetN == 1'b0) begin 
				SM_PS <= IDLE_ST ; 
				Xspeed_PS <= INITIAL_X_SPEED; 
				Xposition_PS <= INITIAL_X;
				Yposition_PS <= INITIAL_Y;
				Xspeed_PS <= 0;
				
				end 	
			else begin 
				SM_PS  <= SM_NS ;
				Xspeed_PS   <= Xspeed_NS    ; 
				Yspeed_PS <= Yspeed_NS;
				Xposition_PS <=  Xposition_NS    ;
				Yposition_PS <= Yposition_NS;
			end ; 
		end // end fsm_sync

 
 ///-----------------
 
 
always_comb 
begin
	// set default values 
		 SM_NS = SM_PS  ;
		 Xspeed_NS  = Xspeed_PS ; 
		 Yspeed_NS = Yspeed_PS;
		 Xposition_NS =  Xposition_PS ;
		 Yposition_NS = Yposition_PS;
		 hit_edge = 1'b0;
		 
		 oil_slowing = 6'b0;
		 if(oil_hit != 4'h9)
			oil_slowing = oil_slowing_param;

	case(SM_PS)
//------------
		IDLE_ST: begin
//------------
		 Xspeed_NS  = INITIAL_X_SPEED ; 
		 Yspeed_NS  = 0 ; 
		 Xposition_NS = FIXED_POINT_MULTIPLIER*INITIAL_X; 
		 Yposition_NS = FIXED_POINT_MULTIPLIER*INITIAL_Y; 

		 if (startOfFrame) 
				SM_NS = MOVE_ST ;
 	
	end
	
//------------
		MOVE_ST:  begin     // moving no colision 
//------------
			Xspeed_NS=0;
			Yspeed_NS = 0;
			if (gameOver)
				SM_NS = IDLE_ST ; 
			if (x_key_right ) 
						Xspeed_NS = current_speed - oil_slowing; 
			else if (x_key_left)
						Xspeed_NS = -current_speed + oil_slowing;
						
						
			if (Xposition_NS<x_FRAME_LEFT || Xposition_NS>x_FRAME_RIGHT)
				Xspeed_NS=0;



			//hitting edges
			
			
			if ((Road_Edge_Collision==2'b01))//hitting right
			begin							
				Xspeed_NS=0;
				Xposition_NS = Xposition_PS - bump_on_collision;
				hit_edge = 1'b1;
				SM_NS = WAIT_FOR_EOF_ST ; 
			end
			
			 
			 if ((Road_Edge_Collision==2'b10))
			begin
				Xspeed_NS=0;
				Xposition_NS = Xposition_PS + bump_on_collision;
				hit_edge = 1'b1;
				SM_NS = WAIT_FOR_EOF_ST ; 
			end
			
			 if (up_key)
				Yspeed_NS = -Y_SPEED_INNER;
			else if (down_key)
				Yspeed_NS = Y_SPEED_INNER;
				//end 	
			if (startOfFrame) 
						SM_NS = POSITION_CHANGE_ST ; 
		end 
				
//--------------------
		WAIT_FOR_EOF_ST: begin  // change speed already done once, now wait for EOF 
//--------------------
			
			if (startOfFrame) 
				SM_NS = POSITION_CHANGE_ST ; 
		end 

//------------------------
 		POSITION_CHANGE_ST : begin  // position interpolate 
//------------------------
	
			 Xposition_NS =  Xposition_PS + Xspeed_PS; 
			 Yposition_NS =  Yposition_PS + Yspeed_PS; 
			
		
	    
				SM_NS = POSITION_LIMITS_ST ; 
		end
		
		
//------------------------
		POSITION_LIMITS_ST : begin  //check if still inside the frame 
//------------------------
		
		
				 if (Xposition_PS < x_FRAME_LEFT ) 
						begin  
							Xposition_NS = x_FRAME_LEFT; 
							if (Xspeed_PS < 0 ) // moving to the left 
									Xspeed_NS = 0 ;
						end ; 
	
				 if (Xposition_PS > x_FRAME_RIGHT) 
						begin  
							Xposition_NS = x_FRAME_RIGHT; 
							if (Xspeed_PS > 0 ) // moving to the right 
									Xspeed_NS = 0;
						end ; 
				
				 if (Yposition_PS < HIGHEST_Y) 
						begin  
							 Yposition_NS = HIGHEST_Y; 
							 if (Yspeed_PS < 0 ) // moving up 
									 Yspeed_NS = 0;
						end ; 
					
				 if (Yposition_PS > LOWEST_Y) 
						begin  
							 Yposition_NS = LOWEST_Y; 
							 if (Yspeed_PS > 0 ) // moving down 
									 Yspeed_NS = 0;
						end ; 
				
				

			SM_NS = MOVE_ST ; 
			
		end
		
endcase  // case 
end		
//return from FIXED point  trunc back to prame size parameters 
  
assign 	topLeftX = Xposition_PS / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = Yposition_PS / FIXED_POINT_MULTIPLIER;
assign	car_speed = (up_key) ? Yspeed_PS : 0;

	

endmodule	
//---------------
 
