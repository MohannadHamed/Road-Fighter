
module counter_fsm2
	(
	input logic clk, 
	input logic resetN, 
	input logic startN, 
	input logic OneSecPulse, 
	input logic timerEnd,
	input logic gameOver,
	input logic collision,
	input logic truck_collision,
	input logic increase_fuel,
	output logic countLoadN, 
	output logic countEnable,
	output logic reduceHeartsNum,
	output logic reduceAllHearts
   );

//-------------------------------------------------------------------------------------------

	enum logic [2:0] {s_idle, s_arm, s_run, s_pause, s_hold, s_hold2, s_hold3, s_increaseCount} counter_ps, counter_ns;
 	
//--------------------------------------------------------------------------------------------
 
always @(posedge clk or negedge resetN)
   begin
	   
   if ( !resetN)  // Asynchronic reset
		counter_ps <= s_idle;
   
	else 		// Synchronic logic FSM
		counter_ps <= counter_ns;
		
	end // always sync
	
//--------------------------------------------------------------------------------------------
always_comb
	begin
	// set all default values 
		counter_ns = counter_ps; 
		countEnable = 1'b0;
		countLoadN = 1'b1;
		reduceHeartsNum = 1'b0;	
		reduceAllHearts = 1'b0;
			
		case (counter_ps)
		
			s_idle: begin
				if (startN == 1'b0) 
					counter_ns = s_arm; 
				end // idle
						
			s_arm: begin
				countLoadN = 1'b0;
				if (startN == 1'b1)begin
					counter_ns = s_run;
					countEnable = 1'b1;
				end
				end // arm
						
			s_run: begin
				countEnable = 1'b1;
				if (increase_fuel)
					counter_ns = s_increaseCount;
				else if (timerEnd == 1'b1 || gameOver)
					counter_ns = s_pause;
				else if (truck_collision)
					counter_ns = s_hold2;
				else if (collision)
					counter_ns = s_hold;		
				end // run
					
			s_pause: begin
				if (startN == 1'b1)
				begin
					countLoadN = 1'b0;
					counter_ns = s_run;
				end
				end // pause
			
			s_hold: begin
					countEnable = 1'b1;
					reduceHeartsNum = 1'b1;
					counter_ns = s_hold3;
				end //hold
				
			s_hold2: begin
					reduceAllHearts = 1'b1;
					counter_ns = s_run;
				end //hold		
			
			s_hold3: begin
				if (!collision && OneSecPulse)
					if (timerEnd == 1'b1 || gameOver)
						counter_ns = s_pause;
					else
						counter_ns = s_run;
				end //hold
			
			s_increaseCount: begin
					countLoadN = 1'b0;
					counter_ns = s_run;
					countEnable = 1'b1;
					
				end //hold					
		endcase
	end // always comb
	
endmodule
