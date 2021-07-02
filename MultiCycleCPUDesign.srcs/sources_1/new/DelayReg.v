`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/19 15:25:11
// Design Name: 
// Module Name: DelayReg
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


module DelayReg(
    input             clk,
    input      [31:0] IData,
    output reg [31:0] OData
);
    always @(negedge clk) begin
        OData <= IData;
    end
endmodule
