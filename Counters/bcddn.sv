
module bcddn
	(
	input  logic clk, 
	input  logic resetN, 
	input  logic loadN, 
	input  logic enable1, 
	input  logic enable2, 
	input  logic fuel,
	output logic [3:0] count1, 
	output logic [3:0] count2,
	output logic [3:0] count3,
	output logic [3:0] count4, 
	output logic [3:0] count5,
	output logic [3:0] count6,
	output logic tc
   );

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
	
	down_counter c1(.clk(clk), 
							.resetN(resetN),
							.loadN(loadN),	
							.enable1(enable1), 
							.enable2(enable2),
							.enable3(1'b1), 	
							.datain(datain1), 
							.count(count1), 
							.tc(tc1)
							);
	
	down_counter c2(.clk(clk), 
							.resetN(resetN),
							.loadN(loadN),	
							.enable1(enable1), 
							.enable2(enable2),
							.enable3(tc1), 	
							.datain(datain2),
							.count(count2), 
							.tc(tc2)    
							 );

	down_counter c3(.clk(clk), 
							.resetN(resetN),
							.loadN(loadN),	
							.enable1(enable1), 
							.enable2(enable2),
							.enable3(tc2 && tc1), 	
							.datain(datain3), 
							.count(count3), 
							.tc(tc3)    
							 );	
	
	down_counter c4(.clk(clk), 
							.resetN(resetN),
							.loadN(loadN),	
							.enable1(enable1), 
							.enable2(enable2),
							.enable3(tc3 && tc2 && tc1), 	
							.datain(datain4), 
							.count(count4), 
							.tc(tc4)    
							 );

	down_counter c5(.clk(clk), 
							.resetN(resetN),
							.loadN(loadN),	
							.enable1(enable1), 
							.enable2(enable2),
							.enable3(tc4 && tc3 && tc2 && tc1), 	
							.datain(datain5), 
							.count(count5), 
							.tc(tc5)    
							 );

	down_counter c6(.clk(clk), 
							.resetN(resetN),
							.loadN(loadN),	
							.enable1(enable1), 
							.enable2(enable2),
							.enable3(tc5 && tc4 && tc3 && tc2 && tc1), 	
							.datain(datain6), 
							.count(count6), 
							.tc(tc6)    
							 );
	assign tc = (fuel) ? tc3 & tc2 & tc1 :tc6 & tc5 & tc4 & tc3 & tc2 & tc1;
 
	
endmodule
