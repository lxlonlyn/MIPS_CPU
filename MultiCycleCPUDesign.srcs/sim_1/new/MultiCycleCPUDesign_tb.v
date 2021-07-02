`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/19 15:46:58
// Design Name: 
// Module Name: MultiCycleCPUDesign_tb
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


module MultiCycleCPUDesign_tb;
    reg clk, rst;

    initial begin
        rst = 1;
        #50 rst = 0;
    end

    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

    wire [31:0] curPC;
    wire [31:0] nextPC;
    wire [31:0] inst;
    wire [31:0] IRinst;
    wire [5:0] op, func;
    wire [4:0] rs, rt, rd;
    wire [31:0] DB;
    wire [31:0] dataDB;
    wire [31:0] A, dataA, B, dataB;
    wire [31:0] result;
    wire [31:0] dataResult;
    wire [1:0] PCSource;
    wire ZeroFlag;
    wire PCWr;
    wire IsRd;
    wire [1:0] RegDst;
    wire RegWr;
    wire ALUSrcA;
    wire ALUSrcB;
    wire [3:0] ALUop;
    wire MemRd, MemWr;
    wire DBDataSrc;
    wire WrRegDSrc;
    wire [31:0] Rw;
    wire [2:0] cur_state;
    wire [31:0] extend;

    CPU_main CPU(
        .clk(clk), 
        .rst(rst),
        .curPC(curPC),
        .nextPC(nextPC),
        .inst(inst),
        .IRinst(IRinst),
        .op(op), 
        .func(func),
        .rs(rs), 
        .rt(rt), 
        .rd(rd),
        .DB(DB),
        .dataDB(dataDB),
        .A(A), 
        .dataA(dataA), 
        .B(B), 
        .dataB(dataB),
        .result(result),
        .dataResult(dataResult),
        .PCSource(PCSource),
        .ZeroFlag(ZeroFlag),
        .PCWr(PCWr),
        .IsRd(IsRd),
        .RegDst(RegDst),
        .RegWr(RegWr),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ALUop(ALUop),
        .MemRd(MemRd),
        .MemWr(MemWr),
        .DBDataSrc(DBDataSrc),
        .WrRegDSrc(WrRegDSrc),
        .Rw(Rw),
        .cur_state(cur_state),
        .extend(extend)
    );
endmodule
