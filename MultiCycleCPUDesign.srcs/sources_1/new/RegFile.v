`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/14 19:40:59
// Design Name: 
// Module Name: RegFile
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


module RegFile(
    input             clk,
    input             RegWr,
    input      [1:0]  RegDst,
    input      [4:0]  Ra, // rs
    input      [4:0]  Rb, // rt
    input      [4:0]  Rd,
    input      [31:0] Dw,
    output     [31:0] Da,
    output     [31:0] Db,

    output reg [31:0] Rw
);
    reg [31:0] regfile [31:0];

    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            regfile[i] = 32'd0;
        end
    end

    assign Da = regfile[Ra];
    assign Db = regfile[Rb];

    // reg [4:0] Rw;
    always @(*) begin
        case (RegDst)
            2'b00: Rw = 5'd31;
            2'b01: Rw = Rb;
            2'b10: Rw = Rd;
        endcase
    end

    always @(negedge clk) begin
        if (RegWr && Rw != 5'd0) begin
            regfile[Rw] <= Dw;
        end
    end

endmodule
