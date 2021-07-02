`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/10 19:21:45
// Design Name: 
// Module Name: RAM
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


module RAM(
    input             MemRd,
    input             MemWr,
    input      [31:0] addr,
    input      [31:0] data_in,
    output reg [31:0] data_out,

    // to be clear
    input DBDataSrc,
    output reg [31:0] DB
);
    reg [7:0] ram [127:0];

    integer i;
    initial begin
        for (i = 0; i < 128; i = i + 1) begin
            ram[i] = 8'd0;
        end
    end

    always @(MemRd or addr or DBDataSrc) begin
        if (MemRd) begin
            data_out = {ram[addr+3], ram[addr+2], ram[addr+1], ram[addr]};
        end
        else begin
            data_out = 32'bz;
        end
        DB = (DBDataSrc == 1'b1) ? data_out : addr;
    end

    always @(MemWr, addr) begin
        if (MemWr == 1'b1) begin
            {ram[addr+3], ram[addr+2], ram[addr+1], ram[addr]} = data_in;
        end
    end
endmodule
