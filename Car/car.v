`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/20 14:53:04
// Design Name: 
// Module Name: car
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


module car(
    input SIG,
    input CLK,
    input RST,
    //motor
    output pwmA1,
    output pwmA2,
    output pwmB1,
    output pwmB2,
    output pwmC1,
    output pwmC2,
    output pwmD1,
    output pwmD2,
    //vga
    output Done,
    output vga_hsync,
    output vga_vsync,
    output [3:0] vga_r,
    output [3:0] vga_b,
    output [3:0] vga_g,
    //ov7670
    input ov7670_PLK,
    output ov7670_XLK,
    input ov7670_VS,
    input ov7670_HS,
    input [7:0] ov7670_Data,
    output ov7670_SCL,
    inout ov7670_SDA,
    output ov7670_RET,
    output ov7670_PWDN,
    //super-sonic
    input ECHO,
    output TRIG,
    output [3:0] LED_SEL,
    output [6:0] LED_SEGS
    );
wire [19:0] data_in;
wire vld;
reg [9:0] control_x,control_y;
wire clk1,clk2;
clk_wiz_0 CLK_BUF(.clk_in1(CLK),.clk_out1(clk1),.clk_out2(clk2));
rx_24bits U1(.CLK(clk1),.RST(RST),.rx(SIG),.rx_vld(vld),.rx_data(data_in));
top_level U2(.clk100(clk2),.btnl(0),.btnc(0),.btnr(0),.config_finished(Done),.vga_hsync(vga_hsync),.vga_vsync(vga_vsync),
             .vga_r(vga_r),.vga_g(vga_g),.vga_b(vga_b),.ov7670_pclk(ov7670_PLK),.ov7670_xclk(ov7670_XLK),
             .ov7670_vsync(ov7670_VS),.ov7670_href(ov7670_HS),.ov7670_data(ov7670_Data),.ov7670_sioc(ov7670_SCL),
             .ov7670_siod(ov7670_SDA),.ov7670_pwdn(ov7670_PWDN),.ov7670_reset(ov7670_RET));
wire BLCK;
my_HCSR04 U3(.CLK(clk1),.RST(RST),.ECHO(ECHO),.TRIG(TRIG),.BLK_O(BLCK),.LED_SEL(LED_SEL),.LED_SEGS(LED_SEGS));
always@(posedge clk1)
begin
if(RST)
begin control_x = 10'b0;control_y = 10'b0; end
else if(vld)
begin
    control_x <= data_in[19:10];
    control_y <= data_in[9:0];
end
else
begin
    control_x <= control_x;
    control_y <= control_y;
end
end
reg [7:0] speed;
reg [8:0] dir;
PWM P1(.CLK(clk1),.speed(speed),.dir_in(dir[1:0]),.pwm1(pwmA1),.pwm2(pwmA2));
PWM P2(.CLK(clk1),.speed(speed),.dir_in(dir[3:2]),.pwm1(pwmB1),.pwm2(pwmB2));
PWM P3(.CLK(clk1),.speed(speed),.dir_in(dir[5:4]),.pwm1(pwmC1),.pwm2(pwmC2));
PWM P4(.CLK(clk1),.speed(speed),.dir_in(dir[7:6]),.pwm1(pwmD1),.pwm2(pwmD2));
always@(*)
if (BLCK==0)
begin 
begin
if (control_x>10'd450 && control_x<10'd550)
begin
if(control_y<10'd400)
begin
speed = (497-control_y)>>1;
dir = 8'b00000000;
end
else if(control_y>10'd550)
begin
speed = (control_y-497)>>1;
dir = 8'b01010101;
end
else
begin
speed = 8'b0;
dir = 4'b0;
end
end
else if(control_x<10'd450)
begin
dir = 8'b01000100;
if(control_y>10'd400 && control_y<10'd550) speed = 8'd50;
else if(control_y<10'd400) speed = (497-control_y)>>1;
else if(control_y>10'd550) speed = (control_y-497)>>1;
end
else if(control_x>10'd550)
begin
dir = 8'b00010001;
if(control_y>10'd400 && control_y<10'd550) speed = 8'd50;
else if(control_y<10'd400) speed = (497-control_y)>>1;
else if(control_y>10'd550) speed = (control_y-497)>>1;
end
end
end
else
begin
if(control_y>10'd550)
begin
speed = (control_y-497)>>1;
dir = 8'b01010101;
end
else
begin
speed = 8'd0;
dir = 8'b00000000;
end
end
//assign test = control_x;
endmodule
