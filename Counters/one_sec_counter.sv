
 module one_sec_counter      	
	(
	input  logic clk, 
	input  logic resetN, 
	input  logic score,
	input logic  [4:0]car_speed,
	input logic  [7:0]car_acceleration,
	output logic one_sec
   );
	
	int oneSecCount ;
	int sec ;		 // gets either one seccond or Turbo top value

// counter limit setting 
	
//       ----------------------------------------------	
	localparam oneSecVal = 26'd50_000_000; // for DE10 board un-comment this line 
//       ----------------------------------------------	
	assign  sec = (score) ? oneSecVal/((car_speed*4)+car_acceleration) : 8*oneSecVal/(car_speed+(car_acceleration/16)); //score or fuel
	
   always_ff @( posedge clk or negedge resetN )
   begin
	
		// asynchronous reset
		if ( !resetN ) begin
			one_sec <= 1'b0;
			oneSecCount <= 26'd0;
		end // if reset
		
		// executed once every clock 	
		else begin
			if (oneSecCount >= sec) begin
				one_sec <= 1'b1;
				oneSecCount <= 0;
			end
			else begin
				oneSecCount <= oneSecCount + 1;
				one_sec		<= 1'b0;
			end
		end // else clk
		
	end // always
endmodule