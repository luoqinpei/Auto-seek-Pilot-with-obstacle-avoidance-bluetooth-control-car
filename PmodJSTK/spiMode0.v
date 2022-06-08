`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/18 13:13:11
// Design Name: 
// Module Name: spiMode0
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


module spiMode0(
    input CLK,
    input RST,
    input sndRec,
    input [7:0] DIN,
    input MISO,
    output MOSI,
    output SCLK,
    output reg BUSY,
    output [7:0] DOUT
    );
    // FSM States
	parameter [1:0] Idle = 2'd0,
					Init = 2'd1,
					RxTx = 2'd2,
					Done = 2'd3;
	reg [4:0] bitCount;							// Number bits read/written
	reg [7:0] rSR ;						// Read shift register
	reg [7:0] wSR ;						// Write shift register
	reg [1:0] pState ;					// Present state
	
	reg CE;
	// Serial clock output, allow if clock enable asserted
	assign SCLK = (CE == 1'b1) ? CLK : 1'b0;
	// Master out slave in, value always stored in MSB of write shift register
	assign MOSI = wSR[7];
	// Connect data output bus to read shift register
	assign DOUT = rSR;
	
	//-------------------------------------
	//			 Write Shift Register
	// 	slave reads on rising edges,
	// change output data on falling edges
	//-------------------------------------
	always @(negedge CLK) begin
		if(RST == 1'b1) begin
			wSR <= 8'h00;
		end
		else begin
		// Enable shift during RxTx state only
		case(pState)
			Idle : begin
				wSR <= DIN;
			end
									
			Init : begin
				wSR <= wSR;
			end
									
			RxTx : begin
				if(CE == 1'b1) begin
					wSR <= {wSR[6:0], 1'b0};
				end
			end
									
			Done : begin
				wSR <= wSR;
			end
			default: wSR<=wSR;
	   endcase
	   end
    end
    
            //-------------------------------------
			//			 Read Shift Register
			// 	master reads on rising edges,
			// slave changes data on falling edges
			//-------------------------------------
			always @(posedge CLK) begin
					if(RST == 1'b1) begin
							rSR <= 8'h00;
					end
					else begin
							// Enable shift during RxTx state only
							case(pState)
									Idle : begin
											rSR <= rSR;
									end
									
									Init : begin
											rSR <= rSR;
									end
									
									RxTx : begin
											if(CE == 1'b1) begin
													rSR <= {rSR[6:0], MISO};
											end
									end
									
									Done : begin
											rSR <= rSR;
									end
									default:rSR<=rSR;
							endcase
					end
			end
			
			//------------------------------
			//		   SPI Mode 0 FSM
			//------------------------------
			always @(negedge CLK) begin
			
					// Reset button pressed
					if(RST == 1'b1) begin
							CE <= 1'b0;				// Disable serial clock
							BUSY <= 1'b0;			// Not busy in Idle state
							bitCount <= 4'h0;		// Clear #bits read/written
							pState <= Idle;		// Go back to Idle state
					end
					else begin
							
							case (pState)
							
								// Idle
								Idle : begin

										CE <= 1'b0;				// Disable serial clock
										BUSY <= 1'b0;			// Not busy in Idle state
										bitCount <= 4'd0;		// Clear #bits read/written
										

										// When send receive signal received begin data transmission
										if(sndRec == 1'b1) begin
											pState <= Init;
										end
										else begin
											pState <= Idle;
										end
										
								end

								// Init
								Init : begin
								
										BUSY <= 1'b1;			// Output a busy signal
										bitCount <= 4'h0;		// Have not read/written anything yet
										CE <= 1'b0;				// Disable serial clock
										
										pState <= RxTx;		// Next state receive transmit
										
								end

								// RxTx
								RxTx : begin

										BUSY <= 1'b1;						// Output busy signal
										bitCount <= bitCount + 1'b1;	// Begin counting bits received/written
										
										// Have written all bits to slave so prevent another falling edge
										if(bitCount >= 4'd8) begin
												CE <= 1'b0;
										end
										// Have not written all data, normal operation
										else begin
												CE <= 1'b1;
										end
										
										// Read last bit so data transmission is finished
										if(bitCount == 4'd8) begin
												pState <= Done;
										end
										// Data transmission is not finished
										else begin
												pState <= RxTx;
										end

								end

								// Done
								Done : begin

										CE <= 1'b0;			// Disable serial clock
										BUSY <= 1'b1;		// Still busy
										bitCount <= 4'd0;	// Clear #bits read/written
										
										pState <= Idle;

								end

								// Default State
								default : pState <= Idle;
								
							endcase
					end
			end
endmodule
