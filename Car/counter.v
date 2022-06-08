`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/20 16:34:35
// Design Name: 
// Module Name: counter
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


module counter(
    input CLK,
    input en_dir1,
    input en_dir2,
    input [7:0] speed,
    output reg out1,
    output reg out2
    );
reg [6:0] cnt;
always@(posedge CLK)
begin
if (cnt<8'd255)
    cnt <= cnt + 1'b1;
else
    cnt <= 7'b0;
end

always@(posedge CLK)
begin
if(en_dir1)
    if(cnt<speed)
        out1 <= 1'b1;
    else
        out1 <= 1'b0;
else
    out1 <= 1'b0;
end

always@(posedge CLK)
begin
if(en_dir2)
    if(cnt<=speed)
        out2 <= 1'b1;
    else
        out2 <= 1'b0;
else
    out2 <= 1'b0;
end

endmodule
