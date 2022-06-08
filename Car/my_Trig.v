`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/06 11:17:32
// Design Name: 
// Module Name: my_Trig
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


module my_Trig(
    input CLK,
    input RST,
    input CLK_EN,
    output reg TRIG_O
    );
    //100ms count
    reg [19:0] cnt=20'b0;
    parameter cnt_max=99999;
    always @ (posedge CLK)begin
        if(RST) cnt<=20'b0;
        else if(CLK_EN)begin
            if(cnt==cnt_max)cnt<=20'b0;
            else cnt<=cnt+1'b1;
        end
        else cnt<=cnt;
    end
    // generate trig signal with 10us pulse
    always @ (posedge CLK)begin
        if(RST)TRIG_O<=0;
        else if(cnt>20'b0 && cnt<=20'd10) TRIG_O<=1;
        else TRIG_O<=0;
    end
    
endmodule
