// (c) Technion IIT, Department of Electrical Engineering 2018 
// Updated by Mor Dahan - January 2022
// 
// Implements the state machine of the bomb mini-project
// FSM, with present and next states

module heartcounter_fsm
	(
	input logic clk, 
	input logic resetN, 
	input logic startN, 
	input logic collision,
	input logic[1:0] heartsNum,
	output logic[1:0] newheartsNum
   );

//-------------------------------------------------------------------------------------------

// state machine decleration 
	enum logic [2:0] {s_idle, s_arm, s_run} bomb_ps, bomb_ns;
 	
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
		newheartsNum = heartsNum;
		case (bomb_ps)
		
			//Note: the implementation of the idle state is already given you as an example
			s_idle: begin
				if (startN == 1'b0) 
					bomb_ns = s_arm; 
				end // idle
						
			s_arm: begin
				if (startN == 1'b1)
					begin
						bomb_ns = s_run;
						newheartsNum = 3;
					end
				end // arm
						
			s_run: begin
				
				if (collision && newheartsNum > 0)
					begin
						newheartsNum = (newheartsNum == 3) ? 2 : heartsNum -1;
						//heartsNum =	heartsNum -1;
					end
				end // run
					
						
						
		endcase
	end // always comb
endmodule
