`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/10 19:13:37
// Design Name: 
// Module Name: ROM
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


module ROM(
    input             IsRd,
    input      [31:0] addr,
    output reg [31:0] DataOut
);
    reg [7:0] rom [512:0];
    initial begin
        $readmemh("C:\\Users\\lonlyn\\MultiCycleCPUDesign\\inst.txt", rom);
    end

    always @(addr, IsRd) begin
        if (IsRd) begin
            DataOut = {rom[addr], rom[addr+1], rom[addr+2], rom[addr+3]};
        end
    end

endmodule
