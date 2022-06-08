`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/06 12:55:59
// Design Name: 
// Module Name: my_HCSR04
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


module my_HCSR04(
    input CLK,//100M时钟
    input RST,//reset
    input ECHO,//外接HC-SR04的ECHO
    output TRIG,//外接HC-SR04的TRIG
    output BLK_O,//有障碍物的信号，高电平代表有
    //output [13:0] LED,
    output [3:0] LED_SEL,//select which led to light.
    output [6:0] LED_SEGS//select which segments to light.
    );
    wire clk_en;
    wire [15:0] time_us;
    wire [13:0] dis_mm;
    
    clk_en106 U1(
                .CLK(CLK),
                .RST(RST),
                .CLK_O(clk_en)
                );
    my_Trig U2(
                .CLK(CLK),
                .RST(RST),
                .CLK_EN(clk_en),
                .TRIG_O(TRIG)
                );
    my_Echo U3(
                .CLK(CLK),
                .RST(RST),
                .CLK_EN(clk_en),
                .ECHO(ECHO),
                .TIME_O(time_us)
                );
    my_calculate U4(
                .CLK(CLK),
                .RST(RST),
                .TIME(time_us),
                .dis_mm(dis_mm)
                );
    reg BLK=0;
    always @ (posedge CLK)begin
        if(RST)BLK<=0;
        else if(dis_mm<=10'd300) BLK<=1;
        else BLK<=0;
    end
    block_dis U5(
                .CLK(CLK),
                .BLK(BLK),
                .LED_SEL(LED_SEL),
                .LED_SEGS(LED_SEGS)
                );
    assign BLK_O=BLK;
    //assign LED=dis_mm;
endmodule
