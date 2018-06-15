`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/15 15:54:01
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
    input[5:0] Op,
    input Zero,
    input Sign,
    input nReset,
    input CLK,
    output PCWre, // 0 PC不更改
    output ALUSrcA, // 0 - 来自寄存器堆， 1 - 来自移位数sa
    output ALUSrcB, // 0 - 来自寄存器堆， 1 - 来自sign或zero扩展的立即数
    output RegWre, //  0 - 无写寄存器指令， 1 - 写寄存器
    output DBDataSrc, // 0 - 来自ALU的输出， 1 - 来自数据存储器的输出
    output WrRegDSrc, //
    output InsMemRw, // 0 - 写指令寄存器， 1 - 读指令寄存器
    output mRD, // 0 - 输出高阻态， 1 - 读数据寄存器
    output mWR, // 0 - 无操作， 1 - 写数据寄存器
    output IRWre, // 1 - IR寄存器写使能
    output ExtSel, //  0 - 立即数0扩展， 1 - 立即数符号扩展
    output reg [1:0] PCSrc,
    output reg [1:0] RegDst, // 0 - 来自rt， 1 - 来自rs
    output reg [2:0] ALUOp,
    output wire[2:0] State
    );
    
    state state(
        .CLK(CLK),
        .RST(nReset),
        .Op(Op),
        .State(State)
    );

    assign PCWre = Op == 6'b111111 || State != 3'b000 ? 0 : 1;
    assign ALUSrcA = Op == 6'b011000 ? 1 : 0;
    assign ALUSrcB = (Op == 6'b000010 || Op == 6'b010010 || Op == 6'b100111 || Op[5:2] == 4'b1100) ? 1 : 0;
    assign DBDataSrc = Op == 6'b110001 ? 1 : 0;
    assign RegWre = (Op == 6'b111111 || Op == 6'b110000 || Op[5:1] == 5'b11100 || Op[5:2] == 4'b1101 || (State != 3'b011 && Op != 6'b111010)) ? 0 : 1;
    assign WrRegDSrc = Op == 6'b111010 ? 0 : 1;
    assign InsMemRw = State == 3'b000 ? 1 : 0;
    assign mRD = (Op == 6'b110001 && State == 3'b100) ? 1 : 0;
    assign mWR = (Op == 6'b110000 && State == 3'b100) ? 1 : 0;
    assign IRWre = State == 3'b000 ? 1 : 0;
    assign ExtSel = (Op == 6'b010010 || Op == 6'b100111) ? 0 : 1;
    
    always@(Op or Zero or Sign) begin
        case(Op)
            6'b000000: begin // add
                PCSrc = 2'b00;
                RegDst = 2'b10;
                ALUOp = 3'b000;
            end
            6'b000001: begin // sub
                PCSrc = 2'b00;
                RegDst = 2'b10;
                ALUOp = 3'b001;
            end
            6'b000010: begin // addi
                PCSrc = 2'b00;
                RegDst = 2'b01;
                ALUOp = 3'b000;
            end
            6'b010000: begin // or
                PCSrc = 2'b00;
                RegDst = 2'b10;
                ALUOp = 3'b101;
            end
            6'b010001: begin // and
                PCSrc = 2'b00;
                RegDst = 2'b10;
                ALUOp = 3'b101;
            end
            6'b010010: begin // ori
                PCSrc = 2'b00;
                RegDst = 2'b01;
                ALUOp = 3'b101;
            end
            6'b011000: begin // sll
                PCSrc = 2'b00;
                RegDst = 2'b10;
                ALUOp = 3'b100;
            end
            6'b100110: begin // slt
                PCSrc = 2'b00;
                RegDst = 2'b10;
                ALUOp = 3'b011;
            end
            6'b100111: begin // sltiu
                PCSrc = 2'b00;
                RegDst = 2'b01;
                ALUOp = 3'b010;
            end
            6'b110000: begin // sw
                PCSrc = 2'b00;
                RegDst = 2'b00;
                ALUOp = 3'b000;
            end
            6'b110001: begin // lw
                PCSrc = 2'b00;
                RegDst = 2'b01;
                ALUOp = 3'b000;
            end
            6'b110100: begin // beq
                PCSrc = Zero == 0 ? 2'b00 : 2'b01;
                RegDst = 2'b00;
                ALUOp = 3'b001;
            end
            6'b110110: begin // bltz
                PCSrc = (Zero == 1 || Sign == 0) ? 2'b00 : 2'b01;
                RegDst = 2'b00;
                ALUOp = 3'b001;
            end
            6'b111000: begin // j
                PCSrc = 2'b11;
                RegDst = 2'b00;
                ALUOp = 3'b001;
            end
            6'b111001: begin // jr
                PCSrc = 2'b10;
                RegDst = 2'b00;
                ALUOp = 3'b000;
            end
            6'b111010: begin // jal
                PCSrc =2'b11;
                RegDst = 2'b00;
                ALUOp = 3'b000;
            end
            6'b111111: begin // halt
                PCSrc = 2'b00;
                RegDst = 2'b00;
                ALUOp = 3'b000;
            end
            default: begin
                PCSrc = 2'b00;
                RegDst = 2'b00;
                ALUOp = 3'b000;
            end
        endcase
    end
    
endmodule
