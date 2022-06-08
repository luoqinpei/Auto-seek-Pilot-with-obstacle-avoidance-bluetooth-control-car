`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/18 18:57:55
// Design Name: 
// Module Name: bluetooth_tx
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


module bluetooth_tx(
    input CLK,//100MHZ clock from W5
    input RST,
    input [7:0] tx_data,
    input tx_vld,
    output reg tx
    );
    //1200bps 
    parameter bps_end=41667;
    parameter bit_end=9;
    reg [7:0] temp_data;
    reg tx_flag;
    reg [29:0] bps_cnt;
    reg [4:0] bit_cnt;
    wire start_bps_cnt,end_bps_cnt;
    wire start_bit_cnt,end_bit_cnt;
    assign start_bps_cnt=tx_flag;
    assign end_bps_cnt=start_bps_cnt && (bps_cnt==bps_end-1);
    assign start_bit_cnt=end_bps_cnt;
    assign end_bit_cnt=start_bit_cnt && (bit_cnt==(bit_end-1));
    
    always @ (posedge CLK)begin
        if(RST) temp_data<=8'b0;
        else if (tx_vld) temp_data<=tx_data;
        else temp_data<=temp_data;
    end
    
    always @ (posedge CLK)begin
        if(RST) tx_flag<=0;
        else if(end_bit_cnt)tx_flag<=0;
        else if (tx_vld) tx_flag<=1;
        else tx_flag<=tx_flag;
    end
    
    always @ (posedge CLK)begin
        if (RST)
            bps_cnt<=5'b0;
        else if(start_bps_cnt)begin
            if(end_bps_cnt) bps_cnt<=0;
            else bps_cnt<=bps_cnt+1'b1;
        end
        else bps_cnt<=bps_cnt;
    end
    
    always @ (posedge CLK)begin
        if(RST)bit_cnt<=5'b0;
        else if(start_bit_cnt)begin
            if(end_bit_cnt) bit_cnt<=0;
            else bit_cnt<=bit_cnt+1'b1;
        end
        else bit_cnt<=bit_cnt;
    end
        
    always @ (posedge CLK) begin
        if(RST) tx<=1;
        else if(tx_flag)begin
            if(start_bit_cnt&&(bit_cnt!=bit_end-1))
                tx<=temp_data[bit_cnt];
            else if(bit_cnt==0)
                tx<=0;
            else tx<=tx;
        end
        else tx<=1;
    end
endmodule
