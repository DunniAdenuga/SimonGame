`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:30:49 04/19/2017 
// Design Name: 
// Module Name:    debouncer 
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
module debouncer(
    input raw,
    input clk,
    output reg clean=0
    );

	parameter N = 22;
	reg [N:0] count;
	
	always @(posedge clk) 
	begin
		count <= (raw != clean)? (count + 1) : 0;
		clean <= (count[N] == 1) ? raw : clean;
	end
	
endmodule

