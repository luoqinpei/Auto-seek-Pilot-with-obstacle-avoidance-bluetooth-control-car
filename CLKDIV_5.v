`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:Peking University
// Engineer: CCCHAN
// 
// Create Date: 2022/05/17 21:36:46
// Design Name: CLKDIV_5
// Module Name: CLKDIV_5
// Project Name: DigitalDesign_PmomJSTK
// Target Devices: Artix-7
// Tool Versions: Vivado 2018.3
// Description: generate 5HZ clock
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CLKDIV_5(
    input CLK,   //100MHZ W5 PIN
    input RST,  //reset
    output reg CLK_O  //5HZ Clock output
    );
    parameter cnt_max=9999999;//value to toggle the clock output
    reg [23:0] cnt;//current count 
    
    always @ (posedge CLK)begin//operations about cnt
        if(RST) cnt<=0;
        else if (cnt==cnt_max) cnt<=24'b0;
        else cnt<=cnt+1'b1;
    end
    
    always @ (posedge CLK)begin//operations about CLK_O
        if(RST) CLK_O<=1'b0;
        else if (cnt==cnt_max) CLK_O<=~CLK_O;
        else CLK_O<=CLK_O;
    end
endmodule
