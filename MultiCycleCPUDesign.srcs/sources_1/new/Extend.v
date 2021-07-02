`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/15 20:36:07
// Design Name: 
// Module Name: Extend
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


module Extend(
    input  [15:0] imm16,
    input         ExtType,
    output [31:0] imm32
);
    assign imm32 = {(imm16[15] == 1'b1 && ExtType == 1'b1) ? 16'hFFFF : 16'h0000, imm16};
endmodule
