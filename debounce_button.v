`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:32:18 04/19/2017 
// Design Name: 
// Module Name:    debounce_button_test 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module debounce_buttons( 
	 input b0, b1, b2, b3,
    input clk,
	 output reg [3:0] bp
    );

//	reg [15:0] numBounces = 0;
	wire cleanb0;  
   wire cleanb1;  
	wire cleanb2;
	wire cleanb3;
//	wire [3:0] allbuttons;
   
	debouncer deb0(b0, clk, cleanb0);  
	debouncer deb1(b1, clk, cleanb1);
	debouncer deb2(b2, clk, cleanb2);
	debouncer deb3(b3, clk, cleanb3);
	
//	always@(posedge cleanb0 or posedge cleanb1 or posedge cleanb2 or posedge cleanb3)
//		bp = {cleanb0, cleanb1, cleanb2, cleanb3};
		
	always@(cleanb0 or cleanb1 or cleanb2 or cleanb3)
		bp = {cleanb0, cleanb1, cleanb2, cleanb3};

  /* always@(allbuttons)
	   bp <= allbuttons;
	*/
/*	always@(cleanb0, cleanb1, cleanb2, cleanb3)
		begin
			bp <= (cleanb0 == 1 ? 3'b00 :
					 cleanb1 == 1 ? 3'b01 :
					 cleanb2 == 1 ? 3'b10 :
					 cleanb3 == 1 ? 3'b11 :
					 3'b111);
		end
*/	
endmodule

