`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/19 15:11:35
// Design Name: 
// Module Name: CLKDIV_200
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


module CLKDIV_200(
    input CLK,
    input RST,
    output reg CLK_O
    );
    parameter cnt_max=4999999;//value to toggle the clock output
    reg [29:0] cnt=0;//current count 
    always @ (posedge CLK)begin
      if(RST) cnt<=0;
      else if (cnt==cnt_max) cnt<=0;
      else cnt<=cnt+1'b1;
    end
    
    always @ (posedge CLK)begin
        if(RST) CLK_O<=1'b0;
        else if (cnt==cnt_max) CLK_O<=1'b1;
        else CLK_O<=1'b0;
    end
    
endmodule
