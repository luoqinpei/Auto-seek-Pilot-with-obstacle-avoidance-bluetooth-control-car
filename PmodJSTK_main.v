`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/18 13:50:04
// Design Name: 
// Module Name: PmodJSTK_main
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


module PmodJSTK_main(
    input CLK,
    input RST,
    input MISO,
    input [2:0] SW,
    output SS,
    output MOSI,
    output SCLK,  // Serial clock that controls communication
    output reg [2:0] LED,
    output [3:0] AN,
    output [6:0] SEG,
    output  tx
    );
    
    					
    // Holds data to be sent to PmodJSTK
	wire [7:0] sndData;

	// Signal to send/receive data to/from PmodJSTK
	wire sndRec;

	// Data read from PmodJSTK
	wire [39:0] jstkData;

	// Signal carrying output data that user selected
	wire [9:0] posData;
	
	
	       //-----------------------------------------------
			//  	  			PmodJSTK Interface
			//-----------------------------------------------
			PmodJSTK PmodJSTK_Int(
					.CLK(CLK),
					.RST(RST),
					.sndRec(sndRec),
					.DIN(sndData),
					.MISO(MISO),
					.SS(SS),
					.SCLK(SCLK),
					.MOSI(MOSI),
					.DOUT(jstkData)
			);
			


			//-----------------------------------------------
			//  		Seven Segment Display Controller
			//-----------------------------------------------
			ssd_dis DispCtrl(
					.CLK(CLK),
					.RST(RST),
					.DIN(posData),
					.sel(AN),
					.segs(SEG)
			);
			
			

			//-----------------------------------------------
			//  			 Send Receive Generator
			//-----------------------------------------------
			CLKDIV_5 genSndRec(
					.CLK(CLK),
					.RST(RST),
					.CLK_O(sndRec)
			);
			
			// Use state of switch 0 to select output of X position or Y position data to SSD
			assign posData = (SW[0] == 1'b1) ? {jstkData[9:8], jstkData[23:16]} : {jstkData[25:24], jstkData[39:32]};

			// Data to be sent to PmodJSTK, lower two bits will turn on leds on PmodJSTK
			assign sndData = {8'b100000, {SW[1], SW[2]}};

			// Assign PmodJSTK button status to LED[2:0]
			always @(sndRec or RST or jstkData) begin
					if(RST == 1'b1) begin
							LED <= 3'b000;
					end
					else begin
							LED <= {jstkData[1], {jstkData[2], jstkData[0]}};
					end
			end
			
			//--------------------------------------------------
			//  			 bluetooth enable signal Generator
			//--------------------------------------------------
			wire blue_ena;
			CLKDIV_200 genBluetooth(
					.CLK(CLK),
					.RST(RST),
					.CLK_O(blue_ena)
			);
			reg [19:0]temp_trans;
			always @ (posedge CLK)begin
			     if(RST) temp_trans<=20'b0;
			     else if (blue_ena) temp_trans<={jstkData[9:8], jstkData[23:16],jstkData[25:24], jstkData[39:32]};//Y first and x  then
			     else temp_trans<=temp_trans;
			end
			tx_24bits transmitter(
			         .CLK(CLK), 
			         .RST(RST),
			         .tx_data(temp_trans),
			         .tx_vld(blue_ena),
			         .tx(tx)
		    );
endmodule
