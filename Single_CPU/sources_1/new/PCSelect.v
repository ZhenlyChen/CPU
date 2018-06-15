`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/15 19:40:42
// Design Name: 
// Module Name: PCSelect
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


module PCSelect(
    input [1:0] PCSrc,
    input [31:0] PC4,
    input [31:0] ExtendOut,
    input [25:0] Address,
    output reg [31:0] PC
    );

    always@(PCSrc or PC4 or ExtendOut or Address) begin
       case(PCSrc)
            2'b00: PC = PC4;
            2'b01: PC = PC4 + (ExtendOut << 2);
            2'b10: begin
                PC[31:28] = PC4[31:28];
                PC[27:2] = Address[25:0];
                PC[1:0] = 0;
            end
            2'b11: PC = 0;
            default: PC = 0;
       endcase
    end
endmodule
