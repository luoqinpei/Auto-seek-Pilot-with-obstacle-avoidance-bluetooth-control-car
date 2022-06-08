`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/06 11:09:21
// Design Name: 
// Module Name: clk_en106
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


module clk_en106(
    input CLK,
    input RST,
    output reg CLK_O
    );
    //generate pulse signal with 1M hz frequency,with 10ns width, to enable some module
    parameter cnt_max=99;
    reg [7:0] cnt=8'b0;
    always @ (posedge CLK)begin
        if(RST)cnt<=8'b0;
        else if (cnt==cnt_max) cnt<=8'b0;
        else cnt<=cnt+1'b1;
    end
    
    always @ (posedge CLK)begin
        if(RST)CLK_O<=0;
        else if(cnt==cnt_max) CLK_O<=1;
        else CLK_O<=0;
    end
endmodule
