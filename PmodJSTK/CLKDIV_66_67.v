`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/17 21:49:58
// Design Name: 
// Module Name: CLKDIV_66_67
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CLKDIV_66_67(
    input CLK,
    input RST,
    output reg CLK_O
    );
    
    parameter cnt_max=749;//value to toggle the clock output
    reg [9:0] cnt;//current count 
    
    always @ (posedge CLK)begin//operations about cnt
        if(RST) cnt<=0;
        else if (cnt==cnt_max) cnt<=10'b0;
        else cnt<=cnt+1'b1;
    end
    
    always @ (posedge CLK)begin//operations about CLK_O
        if(RST) CLK_O<=1'b0;
        else if (cnt==cnt_max) CLK_O<=~CLK_O;
        else CLK_O<=CLK_O;
    end
    
endmodule
