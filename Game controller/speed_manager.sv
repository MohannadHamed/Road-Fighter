
module	speed_manager	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input logic faster_key,
					input logic slower_key,

					output logic [4:0] speed
);

localparam frames_faster = 10;
localparam frames_slower = 10;

localparam MAX_SPEED = 27;
localparam MIN_SPEED = 12;


localparam INITIAL_SPEED = 10;


int faster_counter = 4'b0;
int slower_counter = 4'b0;




always_ff @(posedge startOfFrame, negedge resetN)
begin
		if (!resetN)
		begin
			faster_counter <= 0;
			faster_counter <= 0;
			speed <= INITIAL_SPEED;
		end
		
		else
		begin
			if (faster_key)
			begin

				
				if (faster_counter == frames_faster && speed < MAX_SPEED)
				begin
					speed <= speed +1;
					faster_counter <= 0;
				end
				
				else if (faster_counter == frames_faster)
					faster_counter <= 0;				
				else
					faster_counter <= faster_counter + 1;
			end

					
			else if (slower_key)
			begin

				
				if (slower_counter == frames_slower && speed > MIN_SPEED)
				begin
					speed <= speed - 1;
					slower_counter <= 0;
				end
				else if (slower_counter == frames_slower)
					slower_counter <= 0;
				else 
					slower_counter <= slower_counter + 1;
			end
		end
end

endmodule

