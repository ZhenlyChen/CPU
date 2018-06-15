`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/13 19:45:29
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
    output zero
    );
    assign zero = (result == 0) ? 1 : 0;
    always@(ALUOpcode or regA or regB) begin
        case (ALUOpcode)
            3'b000 : result = regA + regB;
            3'b001 : result = regA - regB;
            3'b010 : begin // 带符号左移
                if (regA[31] == 1)
                    result = regB >> (~regA + 1);
                else
                    result = regB << regA;
            end
            3'b011 : result = regA | regB;
            3'b100 : result = regA & regB;
            3'b101 : result = (regA < regB) ? 1 : 0; // 不带符号比较
            3'b110 : begin // 带符号比较
                if (regA < regB && (regA[31] == regB[31]))
                    result = 1;
                else if (regA[31] == 1 && regB[31] == 0)
                    result = 1;
                else
                    result = 0;
            end
            3'b111: result = regA ^ regB;
            default : begin
                result = 32'h00000000;
            end
        endcase
    end
endmodule
