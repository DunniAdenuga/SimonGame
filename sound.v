`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:48:51 04/30/2017 
// Design Name: 
// Module Name:    sound 
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
module sound(
input clk_50M, clk_1Hz,
input playing,
output reg pwm_out
);

reg [16:0] count = 0;
reg tone_out = 0;

always @(posedge clk_50M)
	begin 
		count <= count + 1;
		tone_out <= count[16];
		pwm_out <= tone_out && playing;
	end
	
/** END OF CLOCK LOGIC **/


endmodule
