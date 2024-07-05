

module	freeze	(	
					input		logic	clk,
					input		logic	resetN,
					input logic stratOfFrameIn,
					input logic freeze,
					output logic stratOfFrameOut ,
					output logic make_noise
);

localparam tenth_oneSec = 5_000_000;
localparam seconds_delay = 3;

int counter = 0;

always_ff @(posedge clk)
begin
	make_noise <= 0;
	if (freeze)
		counter <= 0;
	else if (counter < seconds_delay * tenth_oneSec)
		begin
			stratOfFrameOut <= 0;
			counter <= counter + 1;
			make_noise <= 1;
		end
		
	else
		stratOfFrameOut <= stratOfFrameIn;
end
endmodule


