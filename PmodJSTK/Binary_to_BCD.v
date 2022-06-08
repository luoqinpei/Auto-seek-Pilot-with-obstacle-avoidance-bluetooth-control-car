`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/17 22:00:19
// Design Name: 
// Module Name: Binary_to_BCD
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: This module receives a 10 bit binary value and converts it to
//					 a packed binary coded decimal (BCD) using the shift add 3
//					 algorithm.
// The output consists of 4 BCD digits as follows:
//
//								BCDOUT[15:12]	- Thousands place
//								BCDOUT[11:8]	- Hundreds place
//								BCDOUT[7:4]		- Tens place
//								BCDOUT[3:0]		- Ones place
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Binary_to_BCD(
    input CLK,  //100M CLOCK from basys3
    input RST,  //reset
    input START,  //signal to initialize conversion
    input [9:0] BIN,  //binary value to be converted to BCD value
    output reg [15:0] BCDOUT  //After converting , the BCD output, 4 digits, each digit 4bits
    );
    reg [3:0] shiftcount;  //store the number of shifts
    reg [27:0] temp_sr;  //temporary shift register
    
   
   //state machine
   parameter [2:0] idle=3'b000,
                    init=3'b001,
                    shift=3'b010,
                    check=3'b011,
                    done=3'b100;
                    
   reg [2:0] pstate;
   
   always @ (posedge CLK)begin
       if(RST)begin
         BCDOUT<=16'b0;
         temp_sr<=28'b0;
         pstate<=idle;
       end
       else begin
           case(pstate)
               idle:begin
                        BCDOUT<=BCDOUT;
                        temp_sr<=28'b0;
                        if(START)  pstate<=init;
                        else pstate<=idle;
                    end
                    
               init:begin
                        BCDOUT<=BCDOUT;
                        temp_sr<={18'b0,BIN};
                        pstate<=shift;
                    end
                    
               shift:begin
                         BCDOUT<=BCDOUT;
                         temp_sr<={temp_sr[26:0],1'b0};
                         shiftcount<=shiftcount+1'b1;
                         pstate<=check;
                     end
                     
               check:begin
                         BCDOUT<=BCDOUT;
                         if(shiftcount!=5'd12)begin
                            if(temp_sr[27:24] >= 3'd5) begin
							     temp_sr[27:24] <= temp_sr[27:24] + 2'd3;
							end
							if(temp_sr[23:20] >= 3'd5) begin
							     temp_sr[23:20] <= temp_sr[23:20] + 2'd3;
							end
							if(temp_sr[19:16] >= 3'd5) begin
							     temp_sr[19:16] <= temp_sr[19:16] + 2'd3;
							end
							if(temp_sr[15:12] >= 3'd5) begin
							     temp_sr[15:12] <= temp_sr[15:12] + 2'd3;
							end
							pstate<=shift;
					    end
					    else pstate<=done;
					end
			 done:begin
                     BCDOUT<=temp_sr[27:12];
                     temp_sr<=28'b0;
                     shiftcount<=4'b0;
                     pstate<=idle;
			     end
			 default:pstate<=idle;
		endcase
		end
	end
endmodule
