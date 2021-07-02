`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/14 20:58:59
// Design Name: 
// Module Name: ALU
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


module ALU(
    input             ALUSrcA,
    input             ALUSrcB,
    input      [4:0]  sa,
    input      [31:0] extend,
    input      [31:0] DataInA,
    input      [31:0] DataInB,
    input      [3:0]  ALUop,
    output reg        ZeroFlag,
    output reg [31:0] DataOut
);
    reg [31:0] A, B;

    always @(*) begin
        A = (ALUSrcA == 1'b0) ? DataInA : sa;
        B = (ALUSrcB == 1'b0) ? DataInB : extend;
        case (ALUop)
            4'b0000, 4'b0010: begin 
                // ADDU ADD
                DataOut = A + B;
            end
            4'b0001, 4'b0011: begin
                // SUBU SUB
                DataOut = A - B;
            end
            4'b0100: begin
                // AND
                DataOut = A & B;
            end
            4'b0101: begin
                // OR
                DataOut = A | B;
            end
            4'b0110: begin
                // XOR
                DataOut = A ^ B;
            end
            4'b0111: begin
                // NOR
                DataOut = ~(A | B);
            end
            4'b1000, 4'b1001: begin
                // LUI
                DataOut = {B[15:0], 16'd0};
            end
            4'b1011: begin
                // SLT
                case ({A[31], B[31]})
                    2'b01: DataOut = 32'd0;
                    2'b10: DataOut = 32'd1; 
                    default: begin
                        DataOut = (A[30:0] < B[30:0]) ? 1 : 0;
                    end
                endcase
            end
            4'b1010: begin
                // SLTU
                DataOut = (A < B) ? 1 : 0;
            end
            4'b1100: begin
                // SRA
                DataOut = $signed(B) >>> A;
            end
            4'b1110, 4'b1111: begin
                // SLL/SLR
                DataOut = B << A;
            end
            4'b1101: begin
                // SRL
                DataOut = B >> A;
            end
        endcase
        ZeroFlag = ~(|DataOut);
    end

endmodule
