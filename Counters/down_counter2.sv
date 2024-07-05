
module down_counter2
	(
	input logic clk, 
	input logic resetN, 
	input logic loadN, 
	input logic enable1,
	input logic enable2, 
	input logic enable3, 
	input logic [3:0] datain,
	input logic reset_counter,
	output logic [3:0] count,
	output logic tc
   );
	
// Down counter
always_ff @(posedge clk or negedge resetN)
   begin      
      if ( !resetN )// Asynchronic reset
			count = 4'b0;				
      else 	begin		// Synchronic logic		
			if (!loadN) count <= datain;
			else if (reset_counter) count = 4'b0;
			else if (enable1 && enable2 && enable3) 
				count <= count-1;
			end 
	end //always

	// Asynchronic tc
	assign tc = (count == 4'h0) ? 1'b1 : 1'b0;


	
endmodule
