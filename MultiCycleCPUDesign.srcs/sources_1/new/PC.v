`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/07 17:16:04
// Design Name: 
// Module Name: PC
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


module PC(
    input             clk,
    input             rst,
    input             PCWr,
    input      [31:0] next_PC,
    output reg [31:0] cur_PC
);
    initial begin
        cur_PC = 32'd0;
    end

    always @(negedge clk) begin
        if (rst) begin
            cur_PC <= 0;
        end
        else begin
            if (PCWr) begin
                cur_PC <= next_PC;
            end
            else begin
                cur_PC <= cur_PC;
            end
        end
    end
    
endmodule
