`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/13 17:39:01
// Design Name: 
// Module Name: InstSplit
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


module InstSplit(
    input      [31:0] inst,
    output reg [5:0]  op,
    output reg [4:0]  rs,
    output reg [4:0]  rt,
    output reg [4:0]  rd,
    output reg [4:0]  sa,
    output reg [5:0]  func,
    output reg [15:0] imm16,
    output reg [25:0] addr
);
    always @(inst) begin
        op = inst[31:26];
        rs = inst[25:21];
        rt = inst[20:16];
        rd = inst[15:11];
        sa = inst[10:6];
        func = inst[5:0];
        imm16 = inst[15:0];
        addr = inst[25:0];
    end
    
endmodule
