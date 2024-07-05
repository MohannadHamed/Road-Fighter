
module	road_objects_mux	(	
 	
					input		logic	clk,
					input		logic	resetN,
					
					input		logic	oil_DrawingRequest, 
					input		logic	[7:0] oil_RGB, 
					input		logic	fuel_symbol_DrawingRequest, 
					input		logic	[7:0] fuel_symbol_RGB, 
					
					
					input		logic	left_car_1_DrawingRequest, 
					input		logic	[7:0] left_car_1_RGB, 
					input		logic	left_car_2_DrawingRequest, 
					input		logic	[7:0] left_car_2_RGB, 
					input		logic	right_car_1_DrawingRequest, 
					input		logic	[7:0] right_car_1_RGB, 
					input		logic	right_car_2_DrawingRequest, 
					input		logic	[7:0] right_car_2_RGB, 
					input logic right_truck_1,
					input logic right_truck_2,
					input logic left_truck_1,
					input logic left_truck_2,
			
			
			
					input		logic	roadDrawingRequest, 
					input		logic	[7:0] roadRGB, 
			
			 
				   output	logic	drawingRequest,
				   output	logic	[7:0] RGBOut,
					output logic truck_DR,
					output logic car_DR
);


always_comb
begin

	drawingRequest = 1;
	truck_DR = 0;
	car_DR = 0;
	RGBOut = 8'b0;
	if(!resetN) 
			RGBOut <= 8'b0;
	
	
	
	else 
	begin
		if (left_car_1_DrawingRequest == 1'b1 )   begin
			RGBOut <= left_car_1_RGB;  
			if(left_truck_1)
				truck_DR = 1;
				else
				car_DR=1;
			end
		 
		 else if (left_car_2_DrawingRequest == 1'b1 )   begin
			RGBOut <= left_car_2_RGB;
			if(left_truck_2)
				truck_DR = 1;
				else
				car_DR=1;
			end
		 
		 else if (right_car_1_DrawingRequest == 1'b1 )   begin
			RGBOut <= right_car_1_RGB;   
			if(right_truck_1)
				truck_DR = 1;
				else
				car_DR=1;
			end
			
		 else if (right_car_2_DrawingRequest == 1'b1 )   begin
			RGBOut <= right_car_2_RGB;  
			if(right_truck_2)
				truck_DR = 1;
				else
				car_DR=1;
			end
			
			else if (fuel_symbol_DrawingRequest)
				RGBOut <= fuel_symbol_RGB;
			
			else if (oil_DrawingRequest)
				RGBOut <= oil_RGB;
		 
		else if (roadDrawingRequest== 1'b1)
			RGBOut <= roadRGB;
			
		
		
		else drawingRequest <= 0; 
		
	end  
end
 
endmodule


