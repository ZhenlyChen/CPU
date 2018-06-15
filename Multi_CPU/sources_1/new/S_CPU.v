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
    input nReset; // 0 - 初始化PC为0， 1 - PC接受新地址
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
    wire PCWre; // 0 PC不更改
    wire ALUSrcA; // 0 - 来自寄存器堆， 1 - 来自移位数sa
    wire ALUSrcB; // 0 - 来自寄存器堆， 1 - 来自sign或zero扩展的立即数
    wire DBDataSrc; // 0 - 来自ALU的输出， 1 - 来自数据存储器的输出
    wire RegWre; //  0 - 无写寄存器指令， 1 - 写寄存器
    wire WrRegDSrc;
    wire InsMemRw; // 0 - 写指令寄存器， 1 - 读指令寄存器
    wire mRD; // 0 - 输出高阻态， 1 - 读数据寄存器
    wire mWR; // 0 - 无操作， 1 - 写数据寄存器
    wire IRWre;
    wire ExtSel; //  0 - 立即数0扩展， 1 - 立即数符号扩展
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
    
    
    // 五个简单选择器
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
    
    
    InstDecode InstDecode( // 指令译码器
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

    PC PC( // PC寄存器
        .CLK(clk),
        .nReset(nReset),
        .PCWre(PCWre),
        .PCIn(pcIn),
        .PCOut(pc),
        .PC4(pc4));

    ROM InstMem( // 指令寄存器
        .InsMemRw(InsMemRw),
        .addr(pc),
        .dataOut(IRIn));

    ControlUnit ControlUnit(
        .CLK(clk),
        .Zero(ALUZero),
        .nReset(nReset),
        .Sign(ALUSign),
        .Op(op),
        .PCWre(PCWre), // 0 PC不更改
        .ALUSrcA(ALUSrcA), // 0 - 来自寄存器堆， 1 - 来自移位数sa
        .ALUSrcB(ALUSrcB), // 0 - 来自寄存器堆， 1 - 来自sign或zero扩展的立即数
        .DBDataSrc(DBDataSrc), // 0 - 来自ALU的输出， 1 - 来自数据存储器的输出
        .RegWre(RegWre), //  0 - 无写寄存器指令， 1 - 写寄存器
        .WrRegDSrc(WrRegDSrc),
        .InsMemRw(InsMemRw), // 0 - 写指令寄存器， 1 - 读指令寄存器
        .mRD(mRD), // 0 - 输出高阻态， 1 - 读数据寄存器
        .mWR(mWR), // 0 - 无操作， 1 - 写数据寄存器
        .IRWre(IRWre),
        .ExtSel(ExtSel), //  0 - 立即数0扩展， 1 - 立即数符号扩展
        .PCSrc(PCSrc),
        .RegDst(RegDst), // 0 - 来自rt， 1 - 来自rs
        .ALUOp(ALUOp),
        .State(State)
        );

    RAM DataMem(
        .Address(ALUOutDROut),
        .DataIn(BDROut), // [31:24], [23:16], [15:8], [7:0]
        .mRD(mRD), // 为 1，正常读；为 0,输出高组态
        .mWR(mWR), // 为 1，写；为 0，无操作
        .DataOut(MemOut));

endmodule
