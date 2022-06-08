`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/20 16:12:21
// Design Name: 
// Module Name: PWM
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


module PWM(
    input CLK,
    input [7:0] speed,
    input [1:0] dir_in,
    output pwm1,
    output pwm2
    );
wire w_dir1,w_dir2;
direction U1(.CLK(CLK),.dir_in(dir_in),.dir_out1(w_dir1),.dir_out2(w_dir2));
counter U2(.CLK(CLK),.en_dir1(w_dir1),.en_dir2(w_dir2),.speed(speed),.out1(pwm1),.out2(pwm2));
endmodule
