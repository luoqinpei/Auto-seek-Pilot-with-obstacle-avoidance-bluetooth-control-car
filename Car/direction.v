`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/20 16:16:51
// Design Name: 
// Module Name: direction
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


module direction(
    input CLK,
    input [1:0] dir_in,
    output reg dir_out1,
    output reg dir_out2
    );
always@(posedge CLK)
begin
if(dir_in==2'b00)
    begin
    dir_out1 <= 1'b1;
    dir_out2 <= 1'b0;
    end
else if (dir_in==2'b01)
    begin
    dir_out1 <= 1'b0;
    dir_out2 <= 1'b1;
    end
else
     begin
    dir_out1 <= 1'b0;
    dir_out2 <= 1'b0;
    end
end
endmodule
