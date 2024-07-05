// (c) Technion IIT, Department of Electrical Engineering 2021 
module random_car_truck 	
 ( 
	input	logic  clk,
	input	logic  resetN, 
	input	logic	 rise,
	input logic [2:0] level, 
	output logic create_car	
  ) ;

// Generating a random number by latching a fast counter with the rising edge of an input ( e.g. key pressed )
  
localparam SIZE_BITS = 8;
parameter unsigned MIN_VAL = 0;  //set the min and max values 
parameter unsigned MAX_VAL = 255;

	logic unsigned  [SIZE_BITS-1:0] counter/* synthesis keep = 1 */;
	logic rise_d /* synthesis keep = 1 */;
	
	
always_ff @(posedge clk or negedge resetN) begin
		if (!resetN) begin
			create_car <= 0;
			counter <= MIN_VAL;
			rise_d <= 1'b0;
		end
		
		else begin
			counter <= counter+1;
			if ( counter >= MAX_VAL ) // the +1 is done on the next clock 
				counter <=  MIN_VAL ; // set min and max mvalues 
			rise_d <= rise;
			if (rise && !rise_d) // rising edge 
				begin
					if(counter[2:0] >= level)
						create_car <= 1'b1;
					else
						create_car <= 1'b0;
				end
		end
	
	end
 
endmodule

