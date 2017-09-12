`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:27:17 02/17/2012 
// Design Name: 
// Module Name:    display4digit 
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

module display4digit(
    input win, lose, doneNormal, input [3:0] display_bits,
    input clk_50M, 
    output reg an3, an2, an1, an0,
    output reg [6:0] seven_seg
    );
	
	reg [18:0] counter = 0;
	reg [1:0] toptwo;
	reg [3:0] digitselect;
	reg [27:0] A1 = 28'b1000111_1000000_0010010_0000110; //lose
	reg [27:0] A2 = 28'b0010000_1000000_1000000_0100001 ; //win	reg [18:0] counter = 0;
	
	//wire [3:0] value4bit;
	

	
	 always @(posedge clk_50M)
		begin
			counter <= counter + 1;	
			toptwo <= counter[18:17];
			digitselect <= ~ (  toptwo == 2'b00 ? 4'b0001  // Note inversion
													: toptwo == 2'b01 ? 4'b0010
													: toptwo == 2'b10 ? 4'b0100
																: 4'b1000 );
		end
															
	     always@(*)
		  begin
  	         if((win == 1) | (lose == 1))
				   begin
						if(win == 1)
							begin
							an3 = (digitselect == ~4'b1000 ? 0 : 1);
							an2 = (digitselect == ~4'b0100 ? 0 : 1);
							an1 = (digitselect == ~4'b0010 ? 0 : 1);	
							an0 = (digitselect == ~4'b0001 ? 0 : 1);
							seven_seg =   (toptwo == 2'b00 ? A2[6:0]
															: toptwo == 2'b01 ? A2[13:7]
															: toptwo == 2'b10 ? A2[20:14]
																					: A2[27:21] );
							end
						else
							begin								
							an3 = (digitselect == ~4'b1000 ? 0 : 1);
							an2 = (digitselect == ~4'b0100 ? 0 : 1);
							an1 = (digitselect == ~4'b0010 ? 0 : 1);	
							an0 = (digitselect == ~4'b0001 ? 0 : 1);	
							seven_seg   =   (toptwo == 2'b00 ? A1[6:0]
															: toptwo == 2'b01 ? A1[13:7]
															: toptwo == 2'b10 ? A1[20:14]
																					: A1[27:21] );
							end
					end
				else if(doneNormal == 0)
					begin
						an3 = (display_bits == 4'b1000 ? 0 : 1);
						an2 = (display_bits == 4'b0100 ? 0 : 1);
						an1 = (display_bits == 4'b0010 ? 0 : 1);	
						an0 = (display_bits == 4'b0001 ? 0 : 1);
						seven_seg = 7'b100_0000;
						
					end
				else
					begin	
					an3 = 1;
					an2 = 1;
					an1 = 1;
					an0 = 1;
					seven_seg = 7'b000_0000;
					end	
		end 
	

endmodule



