// (c) Technion IIT, Department of Electrical Engineering 2018 
// Updated by Mor Dahan - January 2022
// 
// Implements the state machine of the bomb mini-project
// FSM, with present and next states

module counter_fsm
	(
	input logic clk, 
	input logic resetN, 
	input logic startN, 
	input logic waitN, 
	input logic OneSecPulse, 
	input logic timerEnd,
	
	output logic countLoadN, 
	output logic countEnable
   );

//-------------------------------------------------------------------------------------------

// state machine decleration 
	enum logic [2:0] {s_idle, s_arm, s_run, s_pause, s_hold} bomb_ps, bomb_ns;
 	
//--------------------------------------------------------------------------------------------
//  1.  syncronous code:  executed once every clock to update the current state 
always @(posedge clk or negedge resetN)
   begin
	   
   if ( !resetN )  // Asynchronic reset
		bomb_ps <= s_idle;
   
	else 		// Synchronic logic FSM
		bomb_ps <= bomb_ns;
		
	end // always sync
	
//--------------------------------------------------------------------------------------------
//  2.  asynchornous code: logically defining what is the next state, and the ouptput 
//      							(not seperating to two different always sections)  	
always_comb // Update next state and outputs
	begin
	// set all default values 
		bomb_ns = bomb_ps; 
		countEnable = 1'b0;
		countLoadN = 1'b1;
			
		case (bomb_ps)
		
			//Note: the implementation of the idle state is already given you as an example
			s_idle: begin
				if (startN == 1'b0) 
					bomb_ns = s_arm; 
				end // idle
						
			s_arm: begin
				countLoadN = 1'b0;
				if (startN == 1'b1)
					bomb_ns = s_run;			
				end // arm
						
			s_run: begin
				countLoadN = 1'b1;
				countEnable = 1'b1;
				if (timerEnd == 1'b1)
					bomb_ns = s_idle;
				else if (waitN == 1'b0)
					bomb_ns = s_pause;				
				end // run
					
			s_pause: begin
				countEnable = 1'b0;
				if (waitN == 1'b1  && OneSecPulse==1)
					bomb_ns = s_hold;
				end // pause
			
			s_hold: begin
				countEnable = 1'b0;
				if (OneSecPulse==1)
					bomb_ns = s_run;
				end //hold
						
						
		endcase
	end // always comb
	
endmodule
