`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/09 18:36:59
// Design Name: 
// Module Name: ALU
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

module ALU(
    input [2:0] ALUOpcode,
    input [31:0] regA,
    input [31:0] regB,
    output reg [31:0] result,
    output zero,
    output sign
    );
    assign zero = (result == 0) ? 1 : 0;
    assign sign = result[31] == 0 ? 0 : 1;
    always@(ALUOpcode or regA or regB) begin
        case (ALUOpcode)
            3'b000 : result = regA + regB;
            3'b001 : result = regA - regB;
            3'b010 : result = (regA < regB) ? 1: 0;
            3'b011 : result = (((regA<regB) && (regA[31] == regB[31] )) ||( ( regA[31] ==1 && regB[31] == 0))) ? 1:0;
            3'b100 : begin // ´ø·ûºÅ×óÒÆ
                if (regA[31] == 1)
                    result = regB >> (~regA + 1);
                else
                    result = regB << regA;
            end
            3'b101 : result = regA | regB;
            3'b110 : result = regA & regB;
            3'b111:  result = regA ^ regB;
            default : begin
                result = 32'h00000000;
            end
        endcase
    end
endmodule

