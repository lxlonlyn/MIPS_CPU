`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/15 20:57:05
// Design Name: 
// Module Name: ControlUnit
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


module ControlUnit(
    input            clk, 
    input            rst,
    input            ZeroFlag,

    input      [5:0] op,
    input      [5:0] func,
    // Control signals:
    // PC
    output reg       PCWr,
    output reg [1:0] PCSource,
    // IR
    output reg       IRWr,
    // Extend
    output reg       ExtType,
    // ROM
    output reg       IsRd,
    // RAM
    output reg       MemRd,
    output reg       MemWr,
    // RegFile
    output reg       RegWr,
    output reg [1:0] RegDst,
    // ALU
    output reg       ALUSrcA,
    output reg       ALUSrcB,
    output reg [3:0] ALUop

    ,output reg WrRegDSrc,
    output reg DBDataSrc,
    output [2:0] cur_state
);
    // instructions judge
    // R-type
    assign I_ADD  = (op == 6'b000000 && func == 6'b100000) ? 1 : 0;
    assign I_ADDU = (op == 6'b000000 && func == 6'b100001) ? 1 : 0;
    assign I_SUB  = (op == 6'b000000 && func == 6'b100010) ? 1 : 0;
    assign I_SUBU = (op == 6'b000000 && func == 6'b100011) ? 1 : 0;
    assign I_AND  = (op == 6'b000000 && func == 6'b100100) ? 1 : 0;
    assign I_OR   = (op == 6'b000000 && func == 6'b100101) ? 1 : 0;
    assign I_XOR  = (op == 6'b000000 && func == 6'b100110) ? 1 : 0;
    assign I_NOR  = (op == 6'b000000 && func == 6'b100111) ? 1 : 0;
    assign I_SLT  = (op == 6'b000000 && func == 6'b101010) ? 1 : 0;
    assign I_SLTU = (op == 6'b000000 && func == 6'b101011) ? 1 : 0;
    assign I_SLL  = (op == 6'b000000 && func == 6'b000000) ? 1 : 0;
    assign I_SRL  = (op == 6'b000000 && func == 6'b000010) ? 1 : 0;
    assign I_SRA  = (op == 6'b000000 && func == 6'b000011) ? 1 : 0;
    assign I_SLLV = (op == 6'b000000 && func == 6'b000100) ? 1 : 0;
    assign I_SRLV = (op == 6'b000000 && func == 6'b100110) ? 1 : 0;
    assign I_SRAV = (op == 6'b000000 && func == 6'b000111) ? 1 : 0;
    assign I_JR   = (op == 6'b000000 && func == 6'b001000) ? 1 : 0;
    // I-type
    assign I_ADDI  = (op == 6'b001000);
    assign I_ADDIU = (op == 6'b001001);
    assign I_ANDI  = (op == 6'b001100);
    assign I_ORI   = (op == 6'b001101);
    assign I_XORI  = (op == 6'b001110);
    assign I_LUI   = (op == 6'b001111);
    assign I_LW    = (op == 6'b100011);
    assign I_SW    = (op == 6'b101011);
    assign I_BEQ   = (op == 6'b000100);
    assign I_BNE   = (op == 6'b000101);
    assign I_SLTI  = (op == 6'b001010);
    assign I_SLTIU = (op == 6'b001011);
    // J-type
    assign I_J   = (op == 6'b000010);
    assign I_JAL = (op == 6'b000011);

    // state machine
    reg [2:0] state, next_state;
    localparam sINIT = 3'd0;
    localparam sIF   = 3'd1;
    localparam sID   = 3'd2;
    localparam sEXE  = 3'd3;
    localparam sMEM  = 3'd4;
    localparam sWB   = 3'd5;

    initial begin
        state = sINIT;
        PCWr = 0;
        PCSource = 0;
        IRWr = 0;
        ExtType = 0;
        IsRd = 0;
        MemRd = 0;
        MemWr = 0;
        RegWr = 0;
        RegDst = 2'b11;
        ALUSrcA = 0;
        ALUSrcB = 0;
        ALUop = 0;
        WrRegDSrc = 0;
        DBDataSrc = 0;
    end

    always @(negedge clk) begin
        if (rst) begin
            state <= sINIT;
        end
        else begin
            state <= next_state;
        end
    end

    always @(state or op or ZeroFlag) begin
        case (state)
            sINIT: begin
                next_state = sIF;
            end 
            sIF: begin
                next_state = sID;
            end
            sID: begin
                if (I_J || I_JAL || I_JR) begin
                    next_state = sIF;
                end
                else begin
                    next_state = sEXE;
                end
            end
            sEXE: begin
                if (I_BEQ || I_BNE) begin
                    next_state = sIF;
                end
                else if (I_SW || I_LW) begin
                    next_state = sMEM;
                end
                else begin
                    next_state = sWB;
                end
            end
            sMEM: begin
                if (I_SW) begin
                    next_state = sIF;
                end
                else begin
                    next_state = sWB;
                end
            end
            sWB: begin
                next_state = sIF;
            end
        endcase
    end

    // ALUop define
    localparam ALU_ADD  = 4'b0010;
    localparam ALU_ADDU = 4'b0000;
    localparam ALU_SUB  = 4'b0011;
    localparam ALU_SUBU = 4'b0001;
    localparam ALU_AND  = 4'b0100;
    localparam ALU_OR   = 4'b0101;
    localparam ALU_XOR  = 4'b0110;
    localparam ALU_NOR  = 4'b0111;
    localparam ALU_LUI  = 4'b1000;
    localparam ALU_SLT  = 4'b1011;
    localparam ALU_SLTU = 4'b1010;
    localparam ALU_SRA  = 4'b1100;
    localparam ALU_SLL  = 4'b1110;
    localparam ALU_SLR  = 4'b1111;
    localparam ALU_SRL  = 4'b1101;

    always @(state or op or ZeroFlag) begin
        // PCWr IsRd
        if (state == sIF) begin
            // PCWr = 1'b1;
            IsRd = 1'b1;
        end
        else begin
            // PCWr = 1'b0;
            IsRd = 1'b0;
        end

        if (next_state == sIF) begin
            PCWr = 1'b1;
        end
        else begin
            PCWr = 1'b0;
        end

        // IRWr
        if (state == sIF || next_state == sID) begin
            IRWr = 1'b1;
        end
        else begin
            IRWr = 1'b0;
        end

        // ALUSrcA
        if (I_SLL || I_SRL || I_SRA) begin
            ALUSrcA = 1'b1;
        end
        else begin
            ALUSrcA = 1'b0;
        end

        // ALUSrcB
        if (I_ADDI || I_ADDIU || I_ANDI || I_ORI || I_XORI || I_LW || I_SW || I_SLTI || I_SLTIU || I_LUI) begin
            // add LUI, just use the lower bits
            ALUSrcB = 1'b1;
        end
        else begin
            ALUSrcB = 1'b0;
        end

        // DBDataSrc
        if (I_LW) begin
            DBDataSrc = 1'b1;
        end
        else begin
            DBDataSrc = 1'b0;
        end

        // RegWr RegDst WrRegDSrc
        if ((state == sWB && !I_BEQ && !I_BNE && !I_SW) || (state == sID && I_JAL)) begin
            RegWr = 1'b1;
            if (I_JAL) begin
                WrRegDSrc = 1'b0;
                RegDst = 2'b00;
            end
            else begin
                WrRegDSrc = 1'b1;
                if (I_ADDI || I_ADDIU || I_ANDI || I_ORI || I_XORI || I_LW || I_SLTI || I_SLTIU || I_LUI) begin
                    RegDst = 2'b01;
                end
                else begin
                    RegDst = 2'b10;
                end
            end
        end
        else begin
            RegWr = 1'b0;
        end

        // MemRd MemWr
        MemRd = I_LW;
        MemWr = (state == sMEM && I_SW) ? 1 : 0;

        // ExtType
        ExtType = (I_ADDI || I_SW || I_LW || I_BEQ || I_BNE || I_SLTI) ? 1 : 0;

        // PCSource
        if (I_JR) begin
            PCSource = 2'b10;
        end
        else if ((ZeroFlag && I_BEQ) || (!ZeroFlag && I_BNE)) begin
            PCSource = 2'b01;
        end
        else if (I_J || I_JAL) begin
            PCSource = 2'b11;
        end
        else begin
            PCSource = 2'b00;
        end

        // ALU
        if (op == 6'b000000) begin
            case (func)
                6'b100000: begin
                    ALUop = ALU_ADD;
                end 
                6'b100001: begin
                    ALUop = ALU_ADDU;
                end
                6'b100010: begin
                    ALUop = ALU_SUB;
                end
                6'b100011: begin
                    ALUop = ALU_SUBU;
                end
                6'b100100: begin
                    ALUop = ALU_AND;
                end
                6'b100101: begin
                    ALUop = ALU_OR;
                end
                6'b100110: begin
                    ALUop = ALU_XOR;
                end
                6'b100111: begin
                    ALUop = ALU_NOR;
                end
                6'b101010: begin
                    ALUop = ALU_SLT;
                end
                6'b101011: begin
                    ALUop = ALU_SLTU;
                end
                6'b000000, 6'b000100: begin
                    ALUop = ALU_SLL;
                end
                6'b000010, 6'b000110: begin
                    ALUop = ALU_SRL;
                end
                6'b000011, 6'b000111: begin
                    ALUop = ALU_SRA;
                end
            endcase
        end
        else begin
            case (op)
                // ADDI + SW + LW
                6'b001000, 6'b101011, 6'b100011: begin
                    ALUop = ALU_ADD;
                end 
                6'b001001: begin
                    ALUop = ALU_ADDU;
                end
                6'b001100: begin
                    ALUop = ALU_AND;
                end
                6'b001101: begin
                    ALUop = ALU_OR;
                end
                6'b001110: begin
                    ALUop = ALU_XOR;
                end
                6'b001111: begin
                    ALUop = ALU_LUI;
                end
                6'b000100, 6'b000101: begin
                    ALUop = ALU_SUB;
                end
                6'b001010: begin
                    ALUop = ALU_SLT;
                end
                6'b001011: begin
                    ALUop = ALU_SLTU;
                end
            endcase
        end
    end



    // test
    assign cur_state = state;
endmodule
