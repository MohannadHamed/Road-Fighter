

module	road_mem	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 

					input logic [4:0] Yspeed,
					input logic [1:0] new_x_offset,
					
					
					
					input logic [10:0] Y_position,
					input logic [10:0] x_position,

					output	 logic  [7:0]ROAD_RGB, 
					output	 logic 	[1:0]Road_Edge, //1 if pixel is in either side of the road
					output 	 logic Draw_request,
					output    logic need_new_line,
					output    logic [10:0] left_lane,
					output    logic [10:0] right_lane
					
					
);

//colors
parameter int road_color = 011_011_01;//gray
parameter int line_color = 11111111;//yellow
parameter int edge_color = 000_000_11;//blue


//codes
localparam transparent_code = 3'b000;
localparam road_code = 3'b001;
localparam line_code = 3'b010;
localparam right_edge_code = 3'b110;
localparam left_edge_code = 3'b101;


//block dimensions
localparam int line_block_width = 8;
localparam int line_block_height = 1;

localparam int half_line_block_width = 4;

//total blocks
localparam int blocks_in_x_axis = 640/line_block_width;
localparam int blocks_in_y_axis = 480/line_block_height;
localparam road_width_in_blocks = 26;


//block calculation
logic [blocks_in_y_axis-1:0] current_y_block;
logic [blocks_in_x_axis-1:0] current_x_block;
logic [blocks_in_x_axis-1:0] x_block_offset;

assign current_x_block = x_position/line_block_width;
assign current_y_block = Y_position/line_block_height;
assign x_block_offset = current_x_block-block_lefmost_x_by_Y[current_y_block];


localparam INITIAL_X = 7'h12;


logic [0:road_width_in_blocks-1][2:0] line_virtual_map = 
{left_edge_code, left_edge_code, road_code,road_code,road_code, road_code, road_code, road_code, road_code, road_code, road_code, road_code, line_code, line_code, road_code, road_code, road_code, road_code, road_code, road_code, road_code, road_code, road_code, road_code, right_edge_code, right_edge_code};



logic [0:blocks_in_y_axis-1][6:0] block_lefmost_x_by_Y = 
{blocks_in_y_axis{INITIAL_X}};


logic [0:blocks_in_y_axis-1] block_with_line_by_Y = 
{10{{24{1'b1}}, {24{1'b0}}}};


int pixel_count;

logic [4:0]blocks_to_move;
assign blocks_to_move = Yspeed/4;


 always_ff @(posedge clk)
 begin 	
	
	if (startOfFrame)begin
		pixel_count <= 0;
		need_new_line <= 1;
	end
		

		
	else if (need_new_line)
	begin
		 
		 pixel_count <= pixel_count+1;
		 
		 if (pixel_count >= blocks_to_move) need_new_line <= 0;
		 
		 block_with_line_by_Y[1:blocks_in_y_axis-1]<= block_with_line_by_Y[0:blocks_in_y_axis-2];		
		 block_with_line_by_Y[0]<= block_with_line_by_Y[blocks_in_y_axis-1] ;
		 
		 
		 
		 
		 block_lefmost_x_by_Y[1:blocks_in_y_axis-1] <= block_lefmost_x_by_Y[0:blocks_in_y_axis-2];
		 if (new_x_offset == 2'b01)
			block_lefmost_x_by_Y[0] <= block_lefmost_x_by_Y[0]+1;
			
		else if(new_x_offset == 2'b11)
			block_lefmost_x_by_Y[0] <= block_lefmost_x_by_Y[0]-1;
			
		else 
			block_lefmost_x_by_Y[0] <= block_lefmost_x_by_Y[0];
	end
	
	
	
 end

 
 
 logic [2:0] PIXEL_CODE;



always_comb
begin
	Draw_request = 1'b1;
	Road_Edge = 2'b00;
	ROAD_RGB = road_color;	
		
	if (current_x_block < block_lefmost_x_by_Y[current_y_block] || 
		current_x_block > block_lefmost_x_by_Y[current_y_block]+road_width_in_blocks-1)
			PIXEL_CODE = transparent_code;
	else
		PIXEL_CODE = line_virtual_map[x_block_offset];
	
	if (current_x_block < block_lefmost_x_by_Y[current_y_block])//to the left of the road
		Road_Edge = 2'b10;
	else if (current_x_block > block_lefmost_x_by_Y[current_y_block]+road_width_in_blocks-1)//to the right
		Road_Edge = 2'b01;
	
	case(PIXEL_CODE)

		transparent_code:
		begin
			Draw_request = 1'b0;
		end

		
		
		road_code:
		begin
			ROAD_RGB = road_color;
		end
	
	
	

		line_code:
		begin
			if(block_with_line_by_Y[current_y_block])
				ROAD_RGB = line_color;
			else
				ROAD_RGB = road_color;
		end

		
//---------------------------------
//hitting right edge	
//---------------------------------
		right_edge_code:
		begin
			ROAD_RGB = edge_color;
			Road_Edge = 2'b01;
		end
//---------------------------------
//hitting left edge	
//---------------------------------

		left_edge_code:
		begin
			ROAD_RGB = edge_color;
			Road_Edge = 2'b10;
		end
		
	endcase

end

assign left_lane = (block_lefmost_x_by_Y[0]+3)*line_block_width + half_line_block_width;
assign right_lane = (block_lefmost_x_by_Y[0]+16)*line_block_width + half_line_block_width;

endmodule	
//---------------
 
