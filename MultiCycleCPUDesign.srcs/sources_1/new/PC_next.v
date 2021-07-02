`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/10 17:16:42
// Design Name: 
// Module Name: PC_next
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


module PC_next(
    input             rst,
    input      [31:0] cur_PC,
    input      [1:0]  PCSource,
    input      [31:0] imm16,
    input      [31:0] rs,
    input      [25:0] addr,
    output reg [31:0] next_PC
);
    initial begin
        next_PC = 32'd0;
    end

    wire [31:0] tmpPC;
    assign tmpPC = cur_PC + 4;
    
    always @(*) begin
        if (rst) begin
            next_PC = 32'd0;
        end
        else begin
            case (PCSource)
                2'b00: next_PC = tmpPC;
                2'b01: next_PC = tmpPC + {imm16, 2'b00};
                2'b10: next_PC = rs;
                2'b11: next_PC = {tmpPC[31:28], addr, 2'b00};
            endcase
        end
    end
endmodule
