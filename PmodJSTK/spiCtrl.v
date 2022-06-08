`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/18 13:35:37
// Design Name: 
// Module Name: spiCtrl
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


module spiCtrl(
    input CLK,
    input RST,
    input sndRec,
    input BUSY,
    input [7:0] DIN,
    input [7:0] RxData,
    output reg SS,
    output reg getByte,
    output reg [7:0] sndData,
    output reg [39:0] DOUT
    );
    // FSM States
			parameter [2:0] Idle = 3'd0,
							Init = 3'd1,
							Wait = 3'd2,
							Check = 3'd3,
							Done = 3'd4;
	// Present State
		reg [2:0] pState;

		reg [2:0] byteCnt ;					// Number bits read/written
		parameter byteEndVal = 3'd5;		// Number of bytes to send/receive
		reg [39:0] tmpSR ;		// Temporary shift register to
								// accumulate all five data bytes
	
	
	
	always @(negedge CLK) begin
			if(RST == 1'b1) begin
					// Reest everything
					SS <= 1'b1;
					getByte <= 1'b0;
					sndData <= 8'h00;
					tmpSR <= 40'h0000000000;
					DOUT <= 40'h0000000000;
					byteCnt <= 3'd0;
					pState <= Idle;
			end
			else begin
					
					case(pState)

								// Idle
								Idle : begin

										SS <= 1'b1;								// Disable slave
										getByte <= 1'b0;						// Do not request data
										sndData <= 8'h00;						// Clear data to be sent
										tmpSR <= 40'h0000000000;			// Clear temporary data
										DOUT <= DOUT;							// Retain output data
										byteCnt <= 3'd0;						// Clear byte count

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
								
										SS <= 1'b0;								// Enable slave
										getByte <= 1'b1;						// Initialize data transfer
										sndData <= DIN;						// Store input data to be sent
										tmpSR <= tmpSR;						// Retain temporary data
										DOUT <= DOUT;							// Retain output data
										
										if(BUSY == 1'b1) begin
												pState <= Wait;
												byteCnt <= byteCnt + 1'b1;	// Count
										end
										else begin
												pState <= Init;
										end
										
								end

								// Wait
								Wait : begin

										SS <= 1'b0;								// Enable slave
										getByte <= 1'b0;						// Data request already in progress
										sndData <= sndData;					// Retain input data to send
										tmpSR <= tmpSR;						// Retain temporary data
										DOUT <= DOUT;							// Retain output data
										byteCnt <= byteCnt;					// Count
										
										// Finished reading byte so grab data
										if(BUSY == 1'b0) begin
												pState <= Check;
										end
										// Data transmission is not finished
										else begin
												pState <= Wait;
										end

								end

								// Check
								Check : begin

										SS <= 1'b0;								// Enable slave
										getByte <= 1'b0;						// Do not request data
										sndData <= sndData;					// Retain input data to send
										tmpSR <= {tmpSR[31:0], RxData};	// Store byte just read
										DOUT <= DOUT;							// Retain output data
										byteCnt <= byteCnt;					// Do not count

										// Finished reading bytes so done
										if(byteCnt == 3'd5) begin
												pState <= Done;
										end
										// Have not sent/received enough bytes
										else begin
												pState <= Init;
										end
								end

								// Done
								Done : begin

										SS <= 1'b1;							// Disable slave
										getByte <= 1'b0;					// Do not request data
										sndData <= 8'h00;					// Clear input
										tmpSR <= tmpSR;					// Retain temporary data
										DOUT[39:0] <= tmpSR[39:0];		// Update output data
										byteCnt <= byteCnt;				// Do not count
										
										// Wait for external sndRec signal to be de-asserted
										if(sndRec == 1'b0) begin
												pState <= Idle;
										end
										else begin
												pState <= Done;
										end

								end

								// Default State
								default : pState <= Idle;
						endcase
			end
	end
endmodule
