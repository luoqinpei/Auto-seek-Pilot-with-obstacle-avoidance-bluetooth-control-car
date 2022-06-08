`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/18 10:07:13
// Design Name: 
// Module Name: ssd_dis
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


module ssd_dis(
    input CLK,
    input RST,
    input [9:0] DIN,
    output reg [3:0] sel,
    output reg [6:0] segs
    );
    
    //generate 2kHZ scanning clock
    parameter cnt_max=49999;
    reg [15:0] cnt;
    reg clk_scan;
    always @ (posedge CLK)begin
         if (cnt==cnt_max) cnt<=16'b0;
        else cnt<=cnt+1'b1;
    end
    always @ (posedge CLK)begin
        if (cnt==cnt_max) clk_scan<=1'b1;
        else clk_scan<=1'b0;
    end
    
    //convert binary to bcd
    wire [15:0] BCDdata;
    Binary_to_BCD BtoBCD(.CLK(CLK),.RST(RST),.START(clk_scan),.BIN(DIN),.BCDOUT(BCDdata));
    
    //display
    reg [3:0] dis_data;
    reg [1:0] dis_sel;
    always @ (posedge clk_scan)begin
        if(RST) dis_sel<=0;
        else if (dis_sel==2'b11) dis_sel<=2'b0;
        else dis_sel<=dis_sel+1'b1;
    end
    always @ (posedge clk_scan)begin
        if(RST) sel<=4'b0000;
        else begin
            case(dis_sel)
                2'b00:sel<=4'b1110;
                2'b01:sel<=4'b1101;
                2'b10:sel<=4'b1011;
                2'b11:sel<=4'b0111;
                default:sel<=4'b1111;
            endcase
        end
    end
    always @ (posedge clk_scan)begin
        if(RST)dis_data<=4'b0;
        else begin
            case(dis_sel)
                2'b00:dis_data<=BCDdata[3:0];
                2'b01:dis_data<=BCDdata[7:4];
                2'b10:dis_data<=BCDdata[11:8];
                2'b11:dis_data<=BCDdata[15:12];
                default:dis_data<=4'b0;
            endcase
        end
    end
    always @(*)begin
        case(dis_data)
            4'h0 : segs <= 7'b1000000;  // 0
	        4'h1 : segs <= 7'b1111001;  // 1
			4'h2 : segs <= 7'b0100100;  // 2
			4'h3 : segs <= 7'b0110000;  // 3
		    4'h4 : segs <= 7'b0011001;  // 4
			4'h5 : segs <= 7'b0010010;  // 5
			4'h6 : segs <= 7'b0000010;  // 6
			4'h7 : segs <= 7'b1111000;  // 7
			4'h8 : segs <= 7'b0000000;  // 8
			4'h9 : segs <= 7'b0010000;  // 9
			default : segs <= 7'b1000000;
	   endcase
    end
endmodule
