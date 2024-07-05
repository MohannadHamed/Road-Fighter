
module	collisions_filter	(	
					input	logic	clk,
					input	logic	resetN,
					input logic [1:0]Road_Edge_Collision_in,//1 for right, 2 for left, 0 for none
					input logic objectDR,
					output logic [1:0]Road_Edge_Collision_out
);

always_comb
begin
	if(objectDR)
		Road_Edge_Collision_out = Road_Edge_Collision_in;
	else
		Road_Edge_Collision_out = 2'b00;
end
endmodule

