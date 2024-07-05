
module	road_objects_generator	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input logic [2:0] level,
					input logic start_count,
					
					input logic [10:0] pixel_x,
					input logic rand_seed_left,
					input logic rand_seed_right,
					
					
					input logic straight_ahead,
					input logic [10:0] left_lane,
					input logic [10:0] right_lane,
					
					input logic left_car_1_ready,
					input logic left_car_2_ready,
					input logic right_car_1_ready,
					input logic right_car_2_ready,
					
					output logic left_car_1_enable,
					output logic left_car_2_enable,
					output logic [10:0] left_car_x,
					output logic right_car_1_enable,
					output logic right_car_2_enable,
					output logic [10:0] right_car_x,
					output logic left_truck,
					output logic right_truck,
					output logic oil_enable,
					output logic [10:0] oil_x,
					output logic fuel_symbol_enable,
					output logic [10:0] fuel_symbol_x
					
					
					
);

localparam basic_framesUnit = 4;
int framesUnit;
assign framesUnit = basic_framesUnit-(level>>2);


int fuel_delay = 1_000;

int fuel_symbol_framesUnit;
assign fuel_symbol_framesUnit = basic_framesUnit+(level>>2);


localparam int min_oil_delay = 40;
localparam int min_delay = 20;
int start_delay = 30*min_delay;


int left_freq;
logic [5:0]left_rand_freq;
random_for_road rand_left(.clk(clk), .resetN(resetN), .rise(rand_seed_left || rand_car_seed_left), .dout(left_rand_freq));

int right_freq;
logic [5:0]right_rand_freq;
random_for_road rand_right(.clk(clk), .resetN(resetN), .rise(rand_seed_right || rand_car_seed_right), .dout(right_rand_freq));


int fuel_symbol_freq;
logic [5:0]fuel_symbol_rand_freq = 6'b0;
random_for_road rand_fuel_symbol(.clk(clk), .resetN(resetN), .rise(fuel_symbol_enable||rand_seed_right||rand_seed_left), .dout(fuel_symbol_rand_freq));



int oil_freq;
logic [5:0]oil_rand_freq = 6'b0;
random_for_road rand_oil(.clk(clk), .resetN(resetN), .rise(oil_enable||rand_seed_right||rand_seed_left), .dout(oil_rand_freq));



logic rand_car_seed_left;
logic rand_car_seed_right;
assign rand_car_seed_left = left_car_1_enable||left_car_2_enable;
assign rand_car_seed_right = right_car_1_enable||right_car_2_enable;

logic create_car_left;
random_car_truck create_car_rand_left(.clk(clk), .resetN(resetN), .rise(rand_car_seed_left), .level(level), .create_car(create_car_left));


logic create_car_right;
random_car_truck create_car_rand_right(.clk(clk), .resetN(resetN), .rise(rand_car_seed_right), .level(level), .create_car(create_car_right));


assign oil_x = left_lane + oil_rand_freq;
assign fuel_symbol_x = right_lane - oil_rand_freq;

int left_timer = 0;
int right_timer = 0;
int oil_timer = 0;
int fuel_symbol_timer = 0;

assign left_car_x = left_lane;
assign right_car_x = right_lane;

assign left_truck = ~create_car_left;
assign right_truck = ~create_car_right;


always_ff @(posedge startOfFrame)
begin

	left_car_1_enable <= 0;
	left_car_2_enable <= 0;
	right_car_1_enable <= 0;
	right_car_2_enable <= 0;
	oil_enable <= 0;
	fuel_symbol_enable <= 0;
	if (!resetN)
	begin
		left_timer <= -start_delay;
		right_timer <= -start_delay;
		oil_timer <= -start_delay;
		left_car_1_enable <= 0;
		right_car_1_enable <= 0;
		left_car_2_enable <= 0;
		right_car_2_enable <= 0;
		oil_enable <= 0;
		fuel_symbol_enable <= 0;
	end
	
	
	
	
	
	else 
	begin
	
	
		//oil generation
		if (oil_timer == oil_freq)
		begin
			if(straight_ahead)
			begin
				oil_timer <= 0;
				oil_enable <= 1;
				oil_freq <= (oil_rand_freq + min_oil_delay)*framesUnit;
			end
			else;
		end
		else
			oil_timer <= oil_timer + 1;
			
		//fuel generation
		
		if (fuel_symbol_timer == fuel_delay)
		begin
			if(straight_ahead)
			begin
				fuel_symbol_timer <= 0;
				fuel_symbol_enable <= 1;
				//fuel_symbol_freq <= (fuel_symbol_rand_freq + min_delay)*framesUnit;
			end
			else;
		end
		else
			fuel_symbol_timer <= fuel_symbol_timer + 1;
		
		
		//cars and trucks
		
	
		if (left_car_1_ready || left_car_2_ready)
		begin
			if (left_timer == left_freq)
			begin
				if (straight_ahead)
				begin
					left_timer <= 0;
					left_freq <= (left_rand_freq +min_delay)*framesUnit;
					if (left_car_1_ready)
						left_car_1_enable <= 1;
						
					else 
						left_car_2_enable <= 1;
				end
				else;
			end
			else
				left_timer <= left_timer + 1;
		end
			
			
		if (right_car_1_ready || right_car_2_ready)
		begin
			if (right_timer == right_freq)
			begin
				if (straight_ahead)
				begin
					
					right_timer <= 0;
					right_freq <= (right_rand_freq+min_delay)*framesUnit;
					
					if (right_car_1_ready) 
						right_car_1_enable <= 1;
						
					else 
						right_car_2_enable <= 1;	
					
				end
				else;
			end
			else
				right_timer <= right_timer + 1;
		end
		
	end
	
	
end



endmodule

