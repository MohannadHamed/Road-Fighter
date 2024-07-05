
module	game_controller	(	 
			input	logic	playerDrawingRequest, 
			input	logic	left_car_1_DrawingRequest,
			input	logic	left_car_2_DrawingRequest, 
			input	logic	right_car_1_DrawingRequest, 
			input	logic	right_car_2_DrawingRequest, 
			input logic fuelOver, 
			input logic healthOver,
			input logic hit_Edge,
			input	logic	truck_DrawingRequest,
			input	logic	oil_DrawingRequest,
			input	logic	fuel_symbol_DrawingRequest,
			input	logic	boar_DrawingRequest,
			output logic car_collision, 
			output logic truck_collision, 
			output logic gameOver,
			output logic oil_collision,
			output logic fuel_symbol_collision


);

 
assign car_collision = (( playerDrawingRequest && (left_car_1_DrawingRequest || left_car_2_DrawingRequest || right_car_1_DrawingRequest || right_car_2_DrawingRequest || boar_DrawingRequest)) || hit_Edge); 						 						
assign truck_collision = ( car_collision && truck_DrawingRequest ); 		
assign oil_collision = ( playerDrawingRequest && oil_DrawingRequest ); 
assign fuel_symbol_collision = ( playerDrawingRequest && fuel_symbol_DrawingRequest ); 							
assign gameOver = (fuelOver || healthOver);
endmodule
