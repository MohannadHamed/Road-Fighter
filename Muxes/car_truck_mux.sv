
module	car_truck_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
					
					
					input logic car_DR,
					input logic [7:0] car_RGB,
					input logic truck_DR,
					input logic [7:0] truck_RGB,
					input logic create_truck,
					input logic object_ready,
			  
					output   logic drawing_request,
				   output	logic	[7:0] RGBOut,
					output logic truck_out
);



always_ff@(posedge clk or negedge resetN)
begin
	
	create_truck_PS <= create_truck_NS;
	
	if(!resetN) begin
			RGBOut	<= 8'b0;
			drawing_request <= 1'b0;
			create_truck_PS <= 1'b0;
	end
	
	
	
	
	
	else
	begin
		if (create_truck_PS)
		begin
			truck_out <= 1;
			drawing_request <= truck_DR;
			RGBOut <= truck_RGB;  
		end
		
		else begin
			truck_out <= 0;
			drawing_request <= car_DR;
			RGBOut <= car_RGB;  
		end
	end 
end



logic create_truck_PS;
logic create_truck_NS;
always_comb
begin
	create_truck_NS = create_truck_PS;
	if (object_ready == 1'b1)
		create_truck_NS = create_truck;
end

endmodule


