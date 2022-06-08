`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/20 10:22:19
// Design Name: 
// Module Name: rx_24bits
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


module rx_24bits(
    input CLK,
    input RST,
    input rx,
    output reg rx_vld,
    output  [19:0] rx_data
    );
    /*
    reg [1:0] cnt=2'b00;
    wire vld;
    wire [7:0] dataget;
    bluetooth_rx receiver(
        .CLK(CLK),.RST(RST),.RX(rx),.RX_vld(vld),.RXData(dataget));
    always @ (posedge CLK)begin
        if(RST)cnt<=0;
        else if(vld)cnt<=cnt+1'b1;
        else cnt<=cnt;
    end
    always @ (posedge CLK)begin
        if(RST) rx_vld<=0;
        else if(cnt==2'b00)rx_vld<=1;
        else rx_vld<=0;
    end
    reg [23:0]all_data;
    always @ (posedge CLK)begin
        if(RST) all_data<=20'b0;
        else if(vld && cnt!=2'b00) all_data<={all_data[15:0],dataget};
        else all_data<=all_data;
    end
    
    always @ (posedge CLK)begin
        if(RST) rx_data<=20'b0;
        else if(cnt==2'b00) rx_data<={all_data[23:14],all_data[9:0]};
        else rx_data<=rx_data;
    end
    */
    
    wire vld;
    wire [7:0] dataget;
    bluetooth_rx receiver(
        .CLK(CLK),.RST(RST),.RX(rx),.RX_vld(vld),.RXData(dataget));
    reg [7:0] rec_data;
    always @ (posedge CLK)begin
        if(RST)rec_data<=8'b0;
        else if(vld) rec_data<=dataget;
        else rec_data<=rec_data;
    end
    
    parameter idle=2'b00,rec=2'b01,done=2'b10;
    reg [2:0] pre_state=2'b00,next_state=2'b00;
    reg [2:0] cnt=2'b00;
    always @ (posedge CLK)begin
        if(RST) pre_state<=idle;
        else pre_state<=next_state;
    end
    
    always @ (rec_data or cnt)begin
        if(RST) next_state=idle;
        else begin
            case(pre_state)
                idle:if(rec_data==8'b11111111)next_state=rec;
                     else next_state=idle;
                rec:if(cnt==2'b11)next_state=done;
                    else next_state=rec;
                done:next_state=idle;
                default: next_state=idle;
            endcase
        end
    end
    
    always @ (posedge CLK)begin
        if(RST) cnt<=2'b0;
        else if(pre_state==rec)begin
            if(vld)cnt<=cnt+1'b1;
            else cnt<=cnt;
        end
        else cnt<=2'b0;
    end
    reg [23:0] temp_data=24'b0;
    always @ (posedge CLK)begin
        if(RST) temp_data<=20'b0;
        else if(pre_state==rec)begin
            if(vld)temp_data<={temp_data[15:0],dataget};
            else temp_data<=temp_data;
        end
        else temp_data<=temp_data;
    end
    assign rx_data={temp_data[23:17],temp_data[15:13],temp_data[10:1]};
    
    always @ (posedge CLK) begin
        if(RST) rx_vld<=0;
        else if(pre_state==done)
            rx_vld<=1;
        else rx_vld<=0;
    end
endmodule
