`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/06 13:49:31
// Design Name: 
// Module Name: block_dis
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


module block_dis(
    input CLK,
    input BLK,
    output reg [3:0] LED_SEL,
    output reg [6:0] LED_SEGS
    );
    reg ena_scan;
    integer cnt_scan;
    parameter cnt_scan_max=499999;
    always @ (posedge CLK)begin//scan enable signal
        if(cnt_scan>=cnt_scan_max) cnt_scan<=0;
        else cnt_scan<=cnt_scan+1;
    end
    always @ (posedge CLK)begin
        if(cnt_scan==cnt_scan_max) ena_scan<=1;
        else if (cnt_scan==0) ena_scan<=0;
        else ena_scan<=ena_scan;
    end
    
     reg [1:0] sel=2'b0;
     reg [1:0] data_dis;
     always @ (posedge CLK)begin
        if(ena_scan) 
            if(sel==2'b11) sel<=2'b00;
            else sel<=sel+1'b1;
        else sel<=sel;
    end
     always @ (posedge CLK)begin
      if(ena_scan)
        case(sel)
          2'b00:begin LED_SEL<=4'b1110;data_dis<=2'b00;end
          2'b01:begin LED_SEL<=4'b1101;data_dis<=2'b01;end
          2'b10:begin LED_SEL<=4'b1011;data_dis<=2'b10;end
          2'b11:begin LED_SEL<=4'b0111;data_dis<=2'b11;end
          default:data_dis<=2'b0;
        endcase
      else begin LED_SEL<=LED_SEL;data_dis<=data_dis;end
    end
    
    always @ (data_dis or BLK)begin
        if(BLK)
            case(data_dis)
                2'd0		:	LED_SEGS     =  7'b1000110;	
                2'd1		:	LED_SEGS	 = 	7'b1000000;
                2'd2		:	LED_SEGS	 = 	7'b1000111;
                2'd3		:	LED_SEGS	 = 	7'b0000000;
                default:LED_SEGS=7'b1111111;
            endcase
        else LED_SEGS=7'b1110111;
    end
endmodule
