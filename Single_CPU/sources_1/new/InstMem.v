`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/15 14:37:11
// Design Name: 
// Module Name: InstMem
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


module InstMem(
    input CLK,
    input [31:0] Address,
    input RW, // 0 ÎªÐ´¡£ 1 Îª¶Á
    input [31:0] DataIn,
    output [31:0] DataOut
    );
    reg [7:0] ram [0:60]; //´æ´¢Æ÷
    
    // ¶Á
    assign DataOut[7:0] = (RW == 1)?ram[Address + 3]:8'bz; // z Îª¸ß×èÌ¬
    assign DataOut[15:8] = (RW == 1)?ram[Address + 2]:8'bz;
    assign DataOut[23:16] = (RW == 1)?ram[Address + 1]:8'bz;
    assign DataOut[31:24] = (RW == 1)?ram[Address]:8'bz;
    
    // Ð´
    always@( negedge CLK ) begin
        if( RW == 0 ) begin
            ram[Address] <= DataIn[31:24];
            ram[Address+1] <= DataIn[23:16];
            ram[Address+2] <= DataIn[15:8];
            ram[Address+3] <= DataIn[7:0];
        end
    end
endmodule
