`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:36:01 04/24/2017 
// Design Name: 
// Module Name:    simon_fsm 
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

module simon_fsm(
	 input reset,
    input clk_50M,
	 input b0, b1, b2, b3,
    output [6:0] seven_seg,
    output an0,
	 output an1,
	 output an2,
	 output an3,
	 output pwm_out,
	 output reg led, win, lose
);

/** CLOCK LOGIC **/
reg clk_1Hz = 1'b0; // define 1Hz clk and start value (for simulation)
reg [24:0] counter_50M;
parameter COUNT_50M = 25000000;

// generate a 1 second clock from the 50MHz oscillator
always @(posedge clk_50M or posedge reset)
begin
	if (reset)
		begin
			counter_50M <= 0;
			clk_1Hz <= 1'b0;
		end
	else
		if (counter_50M == COUNT_50M)
			begin
				counter_50M <= 0;
				clk_1Hz <= !clk_1Hz;
			end
		else
			counter_50M <= counter_50M + 1;
end
/** END OF CLOCK LOGIC **/

// For recognizing when the pattern has finished being shown
reg doneNormal = 0;

// For recording the most recent button press
wire [3:0] bp;

reg [3:0] display_bits = 4'b1000; // the display to light up
//reg [1:0] curr_round = 2'b01; // the current round of the game, either 1, 2, or 3
//reg [1:0] next_round = 2'b01;

// Records whether an incorrect button was pressed (ie game was lost)
wire game_over;

/* Button Module */
debounce_buttons mydebounce_buttons(b0, b1, b2, b3, clk_50M, bp);

/* Validate Button Module */
validate_btns my_validate_btns(display_bits, bp, game_over);

/* Sound Module */
reg playing = 0;
sound my_sound(clk_50M, clk_1Hz, playing, pwm_out);

/*Display stuff*/
display4digit myDisplay(win, lose, doneNormal, display_bits, clk_50M, an3, an2, an1, an0,seven_seg);

/** FSM LOGIC **/

reg [4:0] state_reg = 5'b00000;
reg [4:0] next_state = 5'b00000;

/* State declarations */
parameter reset_state        = 4'b0000;
parameter win_state          = 4'b0001;
parameter lose_state         = 4'b0010;

// First round
parameter show_first_pattern_state1 = 5'b0011;
parameter read_first_pattern_state1 = 5'b0100;

// Second round
parameter show_first_pattern_state2 = 5'b00101;
parameter show_second_pattern_state1 = 5'b00110;
parameter read_first_pattern_state2 = 5'b00111;
parameter read_second_pattern_state1 = 5'b01000;

//Third round
parameter show_first_pattern_state3 = 5'b01001;
parameter show_second_pattern_state2 = 5'b01010;
parameter show_third_pattern_state1 = 5'b01011;

parameter read_first_pattern_state3 = 5'b01100;
parameter read_second_pattern_state2 = 5'b01101;
parameter read_third_pattern_state1 = 5'b01110;

/* End of state declarations */

// State register
always @(posedge clk_1Hz or posedge reset)
begin
	if (reset)
		state_reg <= reset_state;
	else
		state_reg <= next_state;
end

// Next state logic
always @(state_reg)
begin
	playing = 0;
	
	// Figure out the next state
	case (state_reg)
		reset_state:
			// extra state here that plays a sound later?
			begin
				doneNormal = 1;
				next_state <= show_first_pattern_state1;
				led = 0;
				win = 0;
				lose = 0;
				playing = 0;
				display_bits <= 4'b0000;
			end
			
				
		show_first_pattern_state1:
			begin
				win = 0;
				lose = 0;
				led = 0;
				//done = 0;
				display_bits <= 4'b1000;
				doneNormal = 0;
				next_state <= read_first_pattern_state1;
			end
			
		read_first_pattern_state1:
			begin
				led = 1;
				doneNormal = 1;
				lose = 0;
				win = 0;
				display_bits <= 4'b1000;
				
				// If the game isn't over
				if (game_over == 0)
					if (bp == display_bits) // if the correct button was pressed
						begin
							next_state <= show_first_pattern_state2;
							playing = 1;
						end

					else // correct button was not pressed
						if (bp == 4'b0000) // no button was pressed; stay where we are
							next_state <= read_first_pattern_state1;
						else // wrong button was actually pressed
							next_state <= lose_state;
					
				// If the game is over
				else
					next_state <= lose_state;
			end
			
		show_first_pattern_state2:
			begin
				win = 0;
				lose = 0;
				led = 0;
				doneNormal = 0;
				display_bits <= 4'b1000;
				next_state <= show_second_pattern_state1;
			end
			
		show_second_pattern_state1:
			begin
				win = 0;
				lose = 0;
				led = 0;
				doneNormal = 0;
				display_bits <= 4'b0100;
				next_state <= read_first_pattern_state2;
			end
			
		read_first_pattern_state2:
			begin
				led = 1;
				doneNormal = 1;
				lose = 0;
				win = 0;
				display_bits <= 4'b1000;
				
				// If the game isn't over
				if (game_over == 0)
					if (bp == display_bits) // if the correct button was pressed
						begin
							next_state <= read_second_pattern_state1;
							playing = 1;
						end

					else // correct button was not pressed
						if (bp == 4'b0000) // no button was pressed; stay where we are
							next_state <= read_first_pattern_state2;
						else // wrong button was actually pressed
							next_state <= lose_state;
					
				// If the game is over
				else
					next_state <= lose_state;
			end
			
		read_second_pattern_state1:
			begin
				led = 1;
				doneNormal = 1;
				lose = 0;
				win = 0;
				display_bits <= 4'b0100;
				
				// If the game isn't over
				if (game_over == 0)
					if (bp == display_bits) // if the correct button was pressed
						begin
							next_state <= show_first_pattern_state3;
							playing = 1;
						end

					else // correct button was not pressed
						if (bp == 4'b0000) // no button was pressed; stay where we are
							next_state <= read_second_pattern_state1;
						else // wrong button was actually pressed
							next_state <= lose_state;
					
				// If the game is over
				else
					next_state <= lose_state;
			end
		
		show_first_pattern_state3:
			begin
				win = 0;
				lose = 0;
				led = 0;
				doneNormal = 0;
				display_bits <= 4'b1000;
				next_state <= show_second_pattern_state2;
			end
			
		show_second_pattern_state2:
			begin
				win = 0;
				lose = 0;
				led = 0;
				doneNormal = 0;
				display_bits <= 4'b0100;
				next_state <= show_third_pattern_state1;
			end
			
		show_third_pattern_state1:
			begin
				win = 0;
				lose = 0;
				led = 0;
				doneNormal = 0;
				display_bits <= 4'b0001;
				next_state <= read_first_pattern_state3;
			end
			
		read_first_pattern_state3:
			begin
				led = 1;
				doneNormal = 1;
				lose = 0;
				win = 0;
				display_bits <= 4'b1000;
				
				// If the game isn't over
				if (game_over == 0)
					if (bp == display_bits) // if the correct button was pressed
						begin
							next_state <= read_second_pattern_state2;
							playing = 1;
						end

					else // correct button was not pressed
						if (bp == 4'b0000) // no button was pressed; stay where we are
							next_state <= read_first_pattern_state3;
						else // wrong button was actually pressed
							next_state <= lose_state;
					
				// If the game is over
				else
					next_state <= lose_state;
			end
			
		read_second_pattern_state2:
			begin
				led = 1;
				doneNormal = 1;
				lose = 0;
				win = 0;
				display_bits <= 4'b0100;
				
				// If the game isn't over
				if (game_over == 0)
					if (bp == display_bits) // if the correct button was pressed
						begin
							next_state <= read_third_pattern_state1;
							playing = 1;
						end

					else // correct button was not pressed
						if (bp == 4'b0000) // no button was pressed; stay where we are
							next_state <= read_second_pattern_state2;
						else // wrong button was actually pressed
							next_state <= lose_state;
					
				// If the game is over
				else
					next_state <= lose_state;
			end
			
			
		read_third_pattern_state1:
			begin
				led = 1;
				doneNormal = 1;
				lose = 0;
				win = 0;
				display_bits <= 4'b0001;
				
				// If the game isn't over
				if (game_over == 0)
					if (bp == display_bits) // if the correct button was pressed
						begin
							next_state <= win_state;
							playing = 1;
						end

					else // correct button was not pressed
						if (bp == 4'b0000) // no button was pressed; stay where we are
							next_state <= read_third_pattern_state1;
						else // wrong button was actually pressed
							next_state <= lose_state;
					
				// If the game is over
				else
					next_state <= lose_state;
			end
			
		win_state:
			begin		
				win = 1;
				lose = 0;
				led = 0;
				doneNormal = 1;
				display_bits <= 4'b0000;
				next_state <= win_state;
			end
			
		lose_state:
			begin
				lose = 1;
				win = 0;
				led = 0;
				doneNormal = 1;
				display_bits <= 4'b0000;
				next_state <= lose_state;
			end
			
		default:
			begin
				doneNormal = 1;
				display_bits <= 4'b0000;
				next_state <= lose_state;
				lose = 0;
				win = 0;
				led = 0;
			end
	endcase
end

/** END OF FSM LOGIC **/

endmodule
