`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/06 11:33:48
// Design Name: 
// Module Name: my_Echo
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


module my_Echo(
    input CLK,
    input RST,
    input CLK_EN,
    input ECHO,
    output reg [15:0] TIME_O
    );
    reg [1:0] r_echo;
    wire pos_echo,neg_echo;
    reg cnt_en;
    reg [15:0] echo_cnt;
    
    always @ (posedge CLK)begin
        if(RST) r_echo<=2'b0;
        else r_echo<={r_echo[0],ECHO};
    end
    assign pos_echo=r_echo[0] & ~r_echo[1];
    assign neg_echo=r_echo[1] & ~r_echo[0];
    
    always @ (posedge CLK)begin
        if(RST) cnt_en<=0;
        else if(pos_echo) cnt_en<=1;
        else if(neg_echo) cnt_en<=0;
        else cnt_en<=cnt_en;
    end
    
    always @ (posedge CLK)begin
        if(RST) echo_cnt<=16'b0;
        else if (!cnt_en) echo_cnt<=16'b0;
        else if (cnt_en)begin
            if(CLK_EN) echo_cnt<=echo_cnt+1'b1;
            else echo_cnt<=echo_cnt;
        end
        else echo_cnt<=echo_cnt;
    end
        
    always @ (posedge CLK)begin
        if(RST) TIME_O<=16'b0;
        else if(neg_echo)TIME_O<=echo_cnt;
        else TIME_O<=TIME_O;
    end
endmodule
