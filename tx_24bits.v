`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/19 22:49:41
// Design Name: 
// Module Name: tx_24bits
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


module tx_24bits(
    input CLK,
    input RST,
    input [19:0] tx_data,
    input tx_vld,
    output tx
    );
    wire clk_800;
    CLKDIV_800 gen8bits(.CLK(CLK),.RST(RST),.CLK_O(clk_800));
    reg [19:0] temp_data=20'b0;
    always @ (posedge CLK)begin
        if(RST) temp_data<=20'b0;
        else if(tx_vld) temp_data<=tx_data;
        else temp_data<=temp_data;
    end
    
    reg [7:0] tx_1,tx_2,tx_3;
    always @ (temp_data)begin
        tx_1={temp_data[19:13],1'b0};
        tx_2={temp_data[12:10],2'b0,temp_data[9:7]};
        tx_3={temp_data[6:0],1'b0};
    end
    
    reg tx_flag;
     reg [1:0] cnt=2'b0;
    always @ (posedge CLK)begin
        if(RST) tx_flag<=0;
        else if (tx_vld) tx_flag<=1;
        else if (cnt==3)  tx_flag<=0;
        else tx_flag<=tx_flag;
    end
   
    always @ (posedge CLK)begin
        if(RST) cnt<=0;
        else if (tx_flag)begin
            if(clk_800)cnt<=cnt+1;
            else cnt<=cnt;
        end
        else if(cnt==3 && clk_800)cnt<=0;
        else cnt<=cnt;
    end
    reg [7:0] snd_data=8'b11111111;
    always @ (posedge CLK)begin
        if(RST) snd_data<=8'b0;
        else if(clk_800)begin
            case(cnt)
                0:snd_data<=tx_1;
                1:snd_data<=tx_2;
                2:snd_data<=tx_3;
                3:snd_data<=8'b11111111;
                default: snd_data<=8'b00000000;
            endcase
        end
        else snd_data<=snd_data;
    end
    
    bluetooth_tx transmitter(
                 .CLK(CLK),.RST(RST),.tx_data(snd_data),.tx_vld(clk_800),.tx(tx));
                 
                
endmodule
