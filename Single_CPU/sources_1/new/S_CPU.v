`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/13 20:32:59
// Design Name: 
// Module Name: S_CPU
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


module S_CPU(clk,nReset, pc, pcIn, rs, rt, ReadData1, ReadData2, ALURes, writeData);
    input clk;
    input nReset; // 0 - ��ʼ��PCΪ0�� 1 - PC�����µ�ַ

    // PC
    output wire [31:0] pc;
    wire [31:0] pc4;
    output wire [31:0] pcIn;

    // InsMem
    wire [31:0] inst;

    // InstDecode
    wire [5:0] op;
    output wire [4:0] rs;
    output wire [4:0] rt;
    wire [4:0] rd;
    wire [4:0] sa;
    wire [15:0] immediate;
    wire [25:0] address;

    // Control
    wire PCWre; // 0 PC������
    wire ALUSrcA; // 0 - ���ԼĴ����ѣ� 1 - ������λ��sa
    wire ALUSrcB; // 0 - ���ԼĴ����ѣ� 1 - ����sign��zero��չ��������
    wire DBDataSrc; // 0 - ����ALU������� 1 - �������ݴ洢�������
    wire RegWre; //  0 - ��д�Ĵ���ָ� 1 - д�Ĵ���
    wire InsMemRw; // 0 - дָ��Ĵ����� 1 - ��ָ��Ĵ���
    wire mRD; // 0 - �������̬�� 1 - �����ݼĴ���
    wire mWR; // 0 - �޲����� 1 - д���ݼĴ���
    wire RegDst; // 0 - ����rt�� 1 - ����rs
    wire ExtSel; //  0 - ������0��չ�� 1 - ������������չ
    wire [1:0] PCSrc;
    wire [2:0] ALUOp;
    
    // Data RAM
    wire [31:0] MemOut;

    // RegFile
    wire [4:0] writeReg;
    output wire [31:0] ReadData1;
    output wire [31:0] ReadData2;
    output wire [31:0] writeData;

    // Sign, zero extend
    wire [31:0] ExtendOut;

    // ALU
    wire [31:0] regA;
    wire [31:0] regB;
    output wire [31:0] ALURes;
    wire ALUZero;
    
    // ALU
    assign regA = ALUSrcA == 0 ? ReadData1 : sa;
    assign regB = ALUSrcB == 0 ? ReadData2 : ExtendOut;
    
    // RegFile
    assign writeReg = RegDst == 0 ? rt : rd;
    assign writeData = DBDataSrc == 0 ? ALURes : MemOut;


    InstDecode instDecode( // ָ��������
        .inst(inst),
        .op(op),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .sa(sa),
        .immediate(immediate),
        .address(address));
        
    PCSelect PCSelect(
        .PCSrc(PCSrc),
        .PC4(pc4),
        .ExtendOut(ExtendOut),
        .Address(address),
        .PC(pcIn));

    Extend Extend(
        .ExtSel(ExtSel),
        .Data(immediate),
        .ExtendOut(ExtendOut));

    RegFile regFile(
        .CLK(clk),
        .RST(nReset),
        .RegWre(RegWre),
        .ReadReg1(rs),
        .ReadReg2(rt),
        .WriteReg(writeReg),
        .WriteData(writeData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2));

    ALU ALU(
        .ALUOpcode(ALUOp),
        .regA(regA),
        .regB(regB),
        .result(ALURes),
        .zero(ALUZero));

    PC PC( // PC�Ĵ���
        .CLK(clk),
        .nReset(nReset),
        .PCWre(PCWre),
        .PCIn(pcIn),
        .PCOut(pc),
        .PC4(pc4));

    ROM instMem( // ָ��Ĵ���
        .InsMemRw(InsMemRw),
        .addr(pc),
        .dataOut(inst));

    ControlUnit controlUnit(
        .Zero(ALUZero),
        .Op(op),
        .PCWre(PCWre), // 0 PC������
        .ALUSrcA(ALUSrcA), // 0 - ���ԼĴ����ѣ� 1 - ������λ��sa
        .ALUSrcB(ALUSrcB), // 0 - ���ԼĴ����ѣ� 1 - ����sign��zero��չ��������
        .DBDataSrc(DBDataSrc), // 0 - ����ALU������� 1 - �������ݴ洢�������
        .RegWre(RegWre), //  0 - ��д�Ĵ���ָ� 1 - д�Ĵ���
        .InsMemRw(InsMemRw), // 0 - дָ��Ĵ����� 1 - ��ָ��Ĵ���
        .mRD(mRD), // 0 - �������̬�� 1 - �����ݼĴ���
        .mWR(mWR), // 0 - �޲����� 1 - д���ݼĴ���
        .RegDst(RegDst), // 0 - ����rt�� 1 - ����rs
        .ExtSel(ExtSel), //  0 - ������0��չ�� 1 - ������������չ
        .PCSrc(PCSrc),
        .ALUOp(ALUOp)
        );

    RAM dataMem(
        .CLK(clk),
        .Address(ALURes),
        .DataIn(ReadData2), // [31:24], [23:16], [15:8], [7:0]
        .nRD(mRD), // Ϊ 0����������Ϊ 1,�������̬
        .nWR(mWR), // Ϊ 0��д��Ϊ 1���޲���
        .DataOut(MemOut));

endmodule
