
module	road_gen	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input logic [2:0] level,
					input logic need_new_line,

					
					
					output logic [1:0] new_x_offset,
					output logic straight_ahead
					
					
);

localparam straight_length = 16;
localparam level_1_length = 1920;

localparam block_length = 16;

localparam straight_ahead_padding = 100;








localparam straight = 2'b00;
localparam soft_right = 2'b01;
localparam soft_left = 2'b11; 


logic [15:0][1:0] straight_map = {16{straight}};
logic [15:0][1:0] soft_right_map = {{15{straight}},soft_right};
logic [15:0][1:0] soft_left_map = {{15{straight}},soft_left};

logic [15:0][1:0] hard_right_map = {2{{7{straight}},soft_right}};
logic [15:0][1:0] hard_left_map = {2{{7{straight}},soft_left}};


logic [10*block_length-1:0][1:0] right_turn;
assign right_turn = {{3{soft_right_map}},{4{hard_right_map}},{3{soft_right_map}}};

logic [10*block_length-1:0][1:0] left_turn;
assign left_turn = {{3{soft_left_map}},{4{hard_left_map}},{4{soft_left_map}}};

logic [10*block_length-1:0][1:0] long_straight;
assign long_straight = {10{straight_map}};


//logic[11:0] current_line = 12'b0;
 
int current_line = 0;

logic [0:straight_length-1][1:0] straight_terrain;
assign straight_terrain =
{straight_map};




logic [0:level_1_length-1][1:0] level_1_terrain;
assign level_1_terrain =
{{5{long_straight}}, right_turn, {5{long_straight}},left_turn};

logic [0:level_1_length-1] level_1_straight;
assign level_1_straight = 
{{3{yes}}, {3{no}},{3{yes}},{3{no}}};


logic[159:0] yes = {10{16'hFFFF}};
logic[159:0] no = {10{16'h0}};





logic [0:level_1_length-1][1:0] level_2_terrain;
assign level_2_terrain =
{left_turn, {3{straight_map}}, right_turn, right_turn, {3{straight_map}},left_turn};





always_ff @(posedge clk)
begin

		if (need_new_line)
			current_line <= current_line + 1;
end

always_comb	
begin
	straight_ahead = 1'b0;
	new_x_offset = 2'b0;
	
	case (level)
	 3'b0: begin
			straight_ahead = 1'b1;	
			new_x_offset = straight_terrain[current_line];
		end
	3'b1: begin
		
		straight_ahead = level_1_straight[current_line];	
		new_x_offset = level_1_terrain[current_line];
		end	
		
	endcase
	
end





endmodule

