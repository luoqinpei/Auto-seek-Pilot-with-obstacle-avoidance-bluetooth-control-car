`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/18 18:48:23
// Design Name: 
// Module Name: bluetooth_rx
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


module bluetooth_rx(
    input CLK,
    input RST,
    input RX,
    output reg RX_vld,
    output reg [7:0] RXData
    );
    parameter bps_end=41667;
    parameter bit_end=9;
    reg rx_temp0,rx_temp1;
    reg rx_flag;
    reg [29:0] bps_cnt;
    reg [4:0] bit_cnt;
    
    wire start_bps_cnt,end_bps_cnt;
    wire start_bit_cnt,end_bit_cnt;
    wire half_bps_flag;
    
    assign start_bps_cnt=rx_flag;
    assign end_bps_cnt=start_bps_cnt && (bps_cnt==bps_end-1);
    assign half_bps_flag=start_bps_cnt && (bps_cnt==bps_end/2-1);
    assign start_bit_cnt=half_bps_flag;
    assign end_bit_cnt=start_bit_cnt && (bit_cnt==bit_end-1);
    
    always @ (posedge CLK)begin
        if(RST) begin rx_temp0<=1;rx_temp1<=1;end
        else begin rx_temp0<=RX;rx_temp1<=rx_temp0;end
    end
    
    always @ (posedge CLK)begin
        if(RST) rx_flag<=0;
        else if (end_bps_cnt && bit_cnt==0) rx_flag<=0;
        else if(rx_temp1==0) rx_flag<=1;
        else rx_flag<=rx_flag;
    end
    
    always @ (posedge CLK)begin
        if(RST) bps_cnt<=0;
        else if(start_bps_cnt)begin 
            if(end_bps_cnt) bps_cnt<=0;
            else bps_cnt<=bps_cnt+1'b1;
        end
        else bps_cnt<=bps_cnt;
    end
    
    always @ (posedge CLK) begin
        if(RST) bit_cnt<=0;
        else if(start_bit_cnt)begin
            if(end_bit_cnt) bit_cnt<=0;
            else bit_cnt<=bit_cnt+1'b1;
        end
        else bit_cnt<=bit_cnt;
    end
    
    always @ (posedge CLK)begin
        if(RST) RXData<=8'b0;
        else if(start_bit_cnt && bit_cnt>=1)
            RXData[bit_cnt-1]<=rx_temp1;
        else RXData<=RXData;
    end
    
    always @ (posedge CLK)begin
        if(RST) RX_vld<=0;
        else if (end_bit_cnt) RX_vld<=1;
        else RX_vld<=0;
    end
endmodule
