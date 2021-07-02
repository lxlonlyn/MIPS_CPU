`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/15 20:55:33
// Design Name: 
// Module Name: CPU_main
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


module CPU_main(
    input clk,
    input rst,
    output [31:0] curPC,
    output [31:0] nextPC,
    output [31:0] inst,
    output [31:0] IRinst,
    output [5:0] op, func,
    output [4:0] rs, rt, rd,
    output [31:0] DB,
    output [31:0] dataDB,
    output [31:0] A, dataA, B, dataB,
    output [31:0] result,
    output [31:0] dataResult,
    output [1:0] PCSource,
    output ZeroFlag,
    output PCWr,
    output IsRd,
    output [1:0] RegDst,
    output RegWr,
    output ALUSrcA,
    output ALUSrcB,
    output [3:0] ALUop,
    output MemRd, MemWr,
    output DBDataSrc,
    output WrRegDSrc,
    output [31:0] Rw,

    output [31:0] extend,
    output [2:0] cur_state
);

    wire [31:0] DataOut;
    wire [4:0] sa;
    wire [15:0] imm16;
    wire [25:0] addr;

    ControlUnit control_unit(
        .clk(clk),
        .rst(rst),
        .ZeroFlag(ZeroFlag),
        .op(op),
        .func(func),
        .PCWr(PCWr),
        .PCSource(PCSource),
        .IRWr(IRWr),
        .ExtType(ExtType),
        .IsRd(IsRd),
        .MemRd(MemRd),
        .MemWr(MemWr),
        .RegWr(RegWr),
        .RegDst(RegDst),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ALUop(ALUop),
        .WrRegDSrc(WrRegDSrc),
        .DBDataSrc(DBDataSrc),
        .cur_state(cur_state)
    ); 

    // PC 
    PC pc(
        .clk(clk),
        .rst(rst),
        .PCWr(PCWr),
        .next_PC(nextPC),
        .cur_PC(curPC)
    );

    PC_next pc_next(
        .rst(rst),
        .cur_PC(curPC),
        .PCSource(PCSource),
        .imm16(extend),
        .rs(A),
        .addr(addr),
        .next_PC(nextPC)
    );

    // ROM
    ROM rom(
        .IsRd(IsRd),
        .addr(curPC),
        .DataOut(inst)
    );

    // IR
    IR ir(
        .clk(clk),
        .IRWr(IRWr),
        .next_inst(inst),
        .cur_inst(IRinst)
    );

    // InstSplit
    InstSplit inst_split(
        .inst(IRinst),
        .op(op),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .sa(sa),
        .func(func),
        .imm16(imm16),
        .addr(addr)
    );

    // Extend
    Extend extend16to32(
        .imm16(imm16),
        .ExtType(ExtType),
        .imm32(extend)
    );

    // RegFile
    RegFile regfile(
        .clk(clk),
        .RegWr(RegWr),
        .RegDst(RegDst),
        .Ra(rs),
        .Rb(rt),
        .Rd(rd),
        .Dw(WrRegDSrc ? dataDB : curPC + 4),
        .Da(A),
        .Db(B),
        .Rw(Rw)
    );

    // ALU
    ALU alu(
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .sa(sa),
        .extend(extend),
        .DataInA(dataA),
        .DataInB(dataB),
        .ALUop(ALUop),
        .ZeroFlag(ZeroFlag),
        .DataOut(result)
    );

    // RAM
    RAM ram(
        .MemRd(MemRd),
        .MemWr(MemWr),
        .addr(result),
        .data_in(dataB),
        .data_out(DataOut),
        .DB(DB),
        .DBDataSrc(DBDataSrc)
    );

    // Delay Register
    DelayReg ADR(
        .clk(clk),
        .IData(A),
        .OData(dataA)
    );

    DelayReg BDR(
        .clk(clk),
        .IData(B),
        .OData(dataB)
    );

    DelayReg ALUoutDR(
        .clk(clk),
        .IData(result),
        .OData(dataResult)
    );

    DelayReg DBDR(
        .clk(clk),
        .IData(DB),
        .OData(dataDB)
    );
endmodule
