`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/18 13:43:12
// Design Name: 
// Module Name: PmodJSTK
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


module PmodJSTK(
    input CLK,
    input RST,
    input sndRec,
    input [7:0] DIN,
    input MISO,
    output SS,
    output SCLK,
    output MOSI,
    output [39:0] DOUT
    );
    
    wire getByte;								// Initiates a data byte transfer in SPI_Int
	wire [7:0] sndData;							// Data to be sent to Slave
	wire [7:0] RxData;							// Output data from SPI_Int
	wire BUSY;									// Handshake from SPI_Int to SPI_Ctrl
			

	// 66.67kHz Clock Divider, period 15us
	wire iSCLK;										// Internal serial clock,
													// not directly output to slave,
													// controls state machine, etc.
	
	//-----------------------------------------------
	//  	  				SPI Controller
	//-----------------------------------------------
			spiCtrl SPI_Ctrl(
					.CLK(iSCLK),
					.RST(RST),
					.sndRec(sndRec),
					.BUSY(BUSY),
					.DIN(DIN),
					.RxData(RxData),
					.SS(SS),
					.getByte(getByte),
					.sndData(sndData),
					.DOUT(DOUT)
			);

			//-----------------------------------------------
			//  	  				  SPI Mode 0
			//-----------------------------------------------
			spiMode0 SPI_Int(
					.CLK(iSCLK),
					.RST(RST),
					.sndRec(getByte),
					.DIN(sndData),
					.MISO(MISO),
					.MOSI(MOSI),
					.SCLK(SCLK),
					.BUSY(BUSY),
					.DOUT(RxData)
			);

			//-----------------------------------------------
			//  	  				SPI Controller
			//-----------------------------------------------
			CLKDIV_66_67 SerialClock(
					.CLK(CLK),
					.RST(RST),
					.CLK_O(iSCLK)
			);
endmodule
