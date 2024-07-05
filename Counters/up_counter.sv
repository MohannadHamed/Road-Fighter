// (c) Technion IIT, Department of Electrical Engineering 2018 

// Implements an up-counter that has also control inputs,
// loadN, enable_cnt and enable to control the count
// and data input - init[3:0] for the load functionality


module up_counter 
	
	(
   // Input, Output Ports
   input logic clk, 
   input logic resetN,
   input logic enable,
	input logic [25:0] MAX_COUNT,
	
   output logic count 
   );
	
	int count_in;


 	 
  always_ff @( posedge clk or negedge resetN )
   begin
     
		if ( !resetN )  count <= 0; // Asynchronic reset
		
		else begin
			if (!enable);//checks if counting is enabled
			
			else begin
				
				if (count_in >= MAX_COUNT)
					begin
							count_in <= 0;
							count <= 1'b1;
					end
						
				else
					begin
						count_in <= count_in + 1'b1;
						count <= 1'b0;
					end
			end
		end
	end
								
			

   //end // always
	 
endmodule

