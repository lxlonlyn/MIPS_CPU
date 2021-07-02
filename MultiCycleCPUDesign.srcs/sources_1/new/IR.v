`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/13 17:02:40
// Design Name: 
// Module Name: IR
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


module IR(
    input             clk,
    input             IRWr,
    input      [31:0] next_inst,
    output reg [31:0] cur_inst
);
    always @(negedge clk) begin
        if (IRWr) begin
            cur_inst <= next_inst;
        end
        else begin
            cur_inst <= cur_inst;
        end
    end

endmodule
