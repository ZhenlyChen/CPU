`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/09 18:40:41
// Design Name: 
// Module Name: Extend
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


module Extend(
    input ExtSel,
    input [15:0] Data,
    output reg [31:0] ExtendOut
    );

    always@(ExtSel or Data) begin
        ExtendOut[15:0] = Data;
        if (ExtSel == 0 || Data[15] == 0)
            ExtendOut[31:16] = 16'h0000;
        else if(ExtSel == 1 && Data[15] != 0)
            ExtendOut[31:16] = 16'hffff;
        else
            ExtendOut = 32'hzzzz;
    end
endmodule

