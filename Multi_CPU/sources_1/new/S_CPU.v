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


module S_CPU(clk,nReset, pc, pcIn, rs, rt, ReadData1, ReadData2,regA, regB, ALURes, writeData,writeReg, IRIn, IROut, State);
    input clk;
    input nReset; // 0 - ��ʼ��PCΪ0�� 1 - PC�����µ�ַ
    output [2:0] State;

    // PC
    output wire [31:0] pc;
    wire [31:0] pc4;
    output wire [31:0] pcIn;

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
    wire WrRegDSrc;
    wire InsMemRw; // 0 - дָ��Ĵ����� 1 - ��ָ��Ĵ���
    wire mRD; // 0 - �������̬�� 1 - �����ݼĴ���
    wire mWR; // 0 - �޲����� 1 - д���ݼĴ���
    wire IRWre;
    wire ExtSel; //  0 - ������0��չ�� 1 - ������������չ
    wire [1:0] PCSrc;
    wire [1:0] RegDst;
    wire [2:0] ALUOp;
    
    // Data RAM
    wire [31:0] MemOut;

    // RegFile
    output wire [4:0] writeReg;
    output wire [31:0] ReadData1;
    output wire [31:0] ReadData2;
    output wire [31:0] writeData;

    // Sign, zero extend
    wire [31:0] ExtendOut;

    // ALU
    output wire [31:0] regA;
    output wire [31:0] regB;
    output wire [31:0] ALURes;
    wire ALUZero;
    wire ALUSign;
    
    // IR
    output wire [31:0] IRIn;
    output wire [31:0] IROut;
    
    // DR
    wire [31:0] ADROut;
    wire [31:0] BDROut;
    wire [31:0] ALUOutDROut;
    wire [31:0] DBDRIn;
    wire [31:0] DBDROut;
    
    
    // �����ѡ����
    // ALU
    assign regA = ALUSrcA == 0 ? ADROut : sa;
    assign regB = ALUSrcB == 0 ? BDROut : ExtendOut;
    
    // RegFile
    assign writeReg = (RegDst[1] == 0) ? ((RegDst[0] == 0) ? 5'b11111 : rt) : ((RegDst[0] == 0) ? rd : 0);
    assign writeData = WrRegDSrc == 0 ? pc4 : DBDROut;
        
    // RAM
    assign DBDRIn = DBDataSrc == 0 ? ALURes : MemOut;

    IR IR(
        .CLK(clk),
        .IRWre(IRWre),
        .InsIn(IRIn),
        .InsOut(IROut)
    );
    
    DR ADR(
        .CLK(clk),
        .DRIn(ReadData1),
        .DROut(ADROut)
    );

    DR BDR(
        .CLK(clk),
        .DRIn(ReadData2),
        .DROut(BDROut)
    );
    
    DR ALUOutDR(
        .CLK(clk),
        .DRIn(ALURes),
        .DROut(ALUOutDROut)
    );
    
    DR DBDR(
        .CLK(clk),
        .DRIn(DBDRIn),
        .DROut(DBDROut)
    );
    
    
    InstDecode InstDecode( // ָ��������
        .inst(IROut),
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
        .RegData(ReadData1),
        .PC(pcIn));

    Extend Extend(
        .ExtSel(ExtSel),
        .Data(immediate),
        .ExtendOut(ExtendOut));

    RegFile RegFile(
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
        .zero(ALUZero),
        .sign(ALUSign));

    PC PC( // PC�Ĵ���
        .CLK(clk),
        .nReset(nReset),
        .PCWre(PCWre),
        .PCIn(pcIn),
        .PCOut(pc),
        .PC4(pc4));

    ROM InstMem( // ָ��Ĵ���
        .InsMemRw(InsMemRw),
        .addr(pc),
        .dataOut(IRIn));

    ControlUnit ControlUnit(
        .CLK(clk),
        .Zero(ALUZero),
        .nReset(nReset),
        .Sign(ALUSign),
        .Op(op),
        .PCWre(PCWre), // 0 PC������
        .ALUSrcA(ALUSrcA), // 0 - ���ԼĴ����ѣ� 1 - ������λ��sa
        .ALUSrcB(ALUSrcB), // 0 - ���ԼĴ����ѣ� 1 - ����sign��zero��չ��������
        .DBDataSrc(DBDataSrc), // 0 - ����ALU������� 1 - �������ݴ洢�������
        .RegWre(RegWre), //  0 - ��д�Ĵ���ָ� 1 - д�Ĵ���
        .WrRegDSrc(WrRegDSrc),
        .InsMemRw(InsMemRw), // 0 - дָ��Ĵ����� 1 - ��ָ��Ĵ���
        .mRD(mRD), // 0 - �������̬�� 1 - �����ݼĴ���
        .mWR(mWR), // 0 - �޲����� 1 - д���ݼĴ���
        .IRWre(IRWre),
        .ExtSel(ExtSel), //  0 - ������0��չ�� 1 - ������������չ
        .PCSrc(PCSrc),
        .RegDst(RegDst), // 0 - ����rt�� 1 - ����rs
        .ALUOp(ALUOp),
        .State(State)
        );

    RAM DataMem(
        .Address(ALUOutDROut),
        .DataIn(BDROut), // [31:24], [23:16], [15:8], [7:0]
        .mRD(mRD), // Ϊ 1����������Ϊ 0,�������̬
        .mWR(mWR), // Ϊ 1��д��Ϊ 0���޲���
        .DataOut(MemOut));

endmodule
