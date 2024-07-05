
module bcdup
	(
	input  logic clk, 
	input  logic resetN, 
	input  logic loadN, 
	input  logic enable1, 
	input  logic enable2, 
	input  logic Time, 
	output logic [3:0] count1, 
	output logic [3:0] count2,
	output logic [3:0] count3,
	output logic [3:0] count4, 
	output logic [3:0] count5,
	output logic [3:0] count6,
	output logic tc
   );
	localparam logic [3:0] max = 4'h9;
	parameter int minute_max = 4'h5;
// Parameters defined as external, here with a default value - to be updated 
// in the upper hierarchy file with the actial bomb down counting values
// -----------------------------------------------------------
	parameter  logic [3:0] datain1 = 4'h0 ; 
	parameter  logic [3:0] datain2 = 4'h0 ;
	parameter  logic [3:0] datain3 = 4'h1 ;
	parameter  logic [3:0] datain4 = 4'h0 ; 
	parameter  logic [3:0] datain5 = 4'h0 ;
	parameter  logic [3:0] datain6 = 4'h0 ;
// -----------------------------------------------------------
	
	logic  tc1, tc2, tc3, tc4, tc5, tc6;// internal variables terminal count 
	
	up_counter2 c1(.clk(clk), 
							.resetN(resetN),
							.loadN(loadN),	
							.enable1(enable1), 
							.enable2(enable2),
							.enable3(1'b1), 	
							.datain(datain1),
							.max(max),
							.count(count1), 
							.tc(tc1)
							);
	

	up_counter2 c2(.clk(clk), 
							.resetN(resetN),
							.loadN(loadN),	
							.enable1(enable1), 
							.enable2(enable2),
							.enable3(tc1), 	
							.datain(datain2), 
							.max(minute_max),
							.count(count2), 
							.tc(tc2)    
							 );
							 
	up_counter2 c3(.clk(clk), 
							.resetN(resetN),
							.loadN(loadN),	
							.enable1(enable1), 
							.enable2(enable2),
							.enable3(tc2 && tc1), 	
							.datain(datain3),
							.max(max),	
							.count(count3), 
							.tc(tc3)    
							 );	
	
	up_counter2 c4(.clk(clk), 
							.resetN(resetN),
							.loadN(loadN),	
							.enable1(enable1), 
							.enable2(enable2),
							.enable3(tc3 && tc2 && tc1), 	
							.datain(datain4),
							.max(minute_max),
							.count(count4), 
							.tc(tc4)    
							 );

	up_counter2 c5(.clk(clk), 
							.resetN(resetN),
							.loadN(loadN),	
							.enable1(enable1), 
							.enable2(enable2),
							.enable3(tc4 && tc3 && tc2 && tc1), 	
							.datain(datain5),
							.max(max),
							.count(count5), 
							.tc(tc5)    
							 );

	up_counter2 c6(.clk(clk), 
							.resetN(resetN),
							.loadN(loadN),	
							.enable1(enable1), 
							.enable2(enable2),
							.enable3(tc5 && tc4 && tc3 && tc2 && tc1), 	
							.datain(datain6),
							.max(max),	
							.count(count6), 
							.tc(tc6)    
							 );
							 
	assign tc =  tc6 & tc5 & tc4 & tc3 & tc2 & tc1;   
					 
	
endmodule
