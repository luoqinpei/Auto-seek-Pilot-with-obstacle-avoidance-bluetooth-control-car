`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/06 11:51:58
// Design Name: 
// Module Name: my_calculate
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


module my_calculate(
    input CLK,
    input RST,
    input [15:0] TIME,
    output [13:0] dis_mm
    );
    wire[23:0] mul_res;
    mult u1(
                .CLK(CLK),
                .A(8'd170),
                .B(TIME),
                .P(mul_res)
                );
    assign dis_mm=mul_res[23:10];
endmodule
