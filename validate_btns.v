`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:35:27 04/21/2017 
// Design Name: 
// Module Name:    validate_btns 
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
module validate_btns(
	input [3:0] display_bits,
	input [3:0] bp,
	output reg game_over
);

	always@(bp, display_bits)
		begin
			if (bp != 4'b0000)
				begin
					game_over = (bp == display_bits) ? 0 : 1;
				end
			else
				game_over = 0;
		end
		
endmodule
