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
    output PCWre, // 0 PC不更改
    output ALUSrcA, // 0 - 来自寄存器堆， 1 - 来自移位数sa
    output DBDataSrc, // 0 - 来自ALU的输出， 1 - 来自数据存储器的输出
    output mRD, // 0 - 输出高阻态， 1 - 读数据寄存器
    output mWR, // 0 - 无操作， 1 - 写数据寄存器
    output ExtSel, //  0 - 立即数0扩展， 1 - 立即数符号扩展
    output InsMemRw, // 0 - 写指令寄存器， 1 - 读指令寄存器
    output reg ALUSrcB, // 0 - 来自寄存器堆， 1 - 来自sign或zero扩展的立即数
    output reg RegWre, //  0 - 无写寄存器指令， 1 - 写寄存器
    output reg RegDst, // 0 - 来自rt， 1 - 来自rs
    output reg [1:0] PCSrc,
    output reg [2:0] ALUOp
    );
    
    assign PCWre = Op == 6'b111111 ? 0 : 1;
    assign ALUSrcA = Op == 6'b011000 ? 1 : 0;
    assign DBDataSrc = Op == 6'b100111 ? 1 : 0;
    assign mRD = Op == 6'b100111 ? 1 : 0;
    assign mWR = Op == 6'b100110 ? 1 : 0;
    assign ExtSel = Op == 6'b010010 ? 0 : 1;
    assign InsMemRw = 1;
    
    always@(Op or Zero) begin
        case(Op)
            6'b000000: begin
                ALUSrcB = 0;
                RegWre = 1;
                RegDst = 1;
                PCSrc = 2'b00;
                ALUOp = 3'b000;
            end
            6'b000001: begin
                ALUSrcB = 1;
                RegWre = 1;
                RegDst = 0;
                PCSrc = 2'b00;
                ALUOp = 3'b000;
            end
            6'b000010: begin
                ALUSrcB = 0;
                RegWre = 1;
                RegDst = 1;
                PCSrc = 2'b00;
                ALUOp = 3'b001;
            end
            6'b010010: begin
                ALUSrcB = 0;
                RegWre = 1;
                RegDst = 1;
                PCSrc = 2'b00;
                ALUOp = 3'b011;
            end
            6'b010001: begin
                ALUSrcB = 0;
                RegWre = 1;
                RegDst = 1;
                PCSrc = 2'b00;
                ALUOp = 3'b100;
            end
            6'b010000: begin
                ALUSrcB = 1;
                RegWre = 1;
                RegDst = 0;
                PCSrc = 2'b00;
                ALUOp = 3'b011;
            end
            6'b011000: begin
                ALUSrcB = 0;
                RegWre = 1;
                RegDst = 1;
                PCSrc = 2'b00;
                ALUOp = 3'b010;
            end
            6'b011011: begin
                ALUSrcB = 1;
                RegWre = 1;
                RegDst = 0;
                PCSrc = 2'b00;
                ALUOp = 3'b110;
            end
            6'b100110: begin
                ALUSrcB = 1;
                RegWre = 0;
                RegDst = 0;
                PCSrc = 2'b00;
                ALUOp = 3'b000;
            end
            6'b100111: begin
                ALUSrcB = 1;
                RegWre = 1;
                RegDst = 0;
                PCSrc = 2'b00;
                ALUOp = 3'b000;
            end
            6'b110000: begin
                ALUSrcB = 0;
                RegWre = 0;
                RegDst = 0;
                PCSrc = Zero == 0 ? 2'b00 : 2'b01;
                ALUOp = 3'b001;
            end
            6'b110001: begin
                ALUSrcB = 0;
                RegWre = 0;
                RegDst = 0;
                PCSrc = Zero == 1 ? 2'b00 : 2'b01;
                ALUOp = 3'b001;
            end
            6'b111000: begin
                ALUSrcB = 0;
                RegWre = 0;
                RegDst = 0;
                PCSrc = 2'b10;
                ALUOp = 3'b000;
            end
            6'b111111: begin
                ALUSrcB = 0;
                RegWre = 0;
                RegDst = 0;
                PCSrc = 2'b00;
                ALUOp = 3'b000;
            end
            default: begin
                ALUSrcB = 0;
                RegWre = 0;
                RegDst = 0;
                PCSrc = 2'b00;
                ALUOp = 3'b000;
            end
        endcase
    end
    
endmodule
