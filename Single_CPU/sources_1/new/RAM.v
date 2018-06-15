`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/13 19:46:34
// Design Name: 
// Module Name: RAM
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


module RAM(
    input CLK,
    input [31:0] Address,
    input [31:0] DataIn, // [31:24], [23:16], [15:8], [7:0]
    input nRD, // Ϊ 0����������Ϊ 1,�������̬
    input nWR, // Ϊ 0��д��Ϊ 1���޲���
    output [31:0] DataOut
    );
    reg [7:0] ram [0:60]; //�洢��
    
    // ��
    assign DataOut[7:0] = (nRD==0)?ram[Address + 3]:8'bz; // z Ϊ����̬
    assign DataOut[15:8] = (nRD==0)?ram[Address + 2]:8'bz;
    assign DataOut[23:16] = (nRD==0)?ram[Address + 1]:8'bz;
    assign DataOut[31:24] = (nRD==0)?ram[Address ]:8'bz;
    
    // д
    always@( negedge CLK ) begin
        if( nWR==0 ) begin
            ram[Address] <= DataIn[31:24];
            ram[Address+1] <= DataIn[23:16];
            ram[Address+2] <= DataIn[15:8];
            ram[Address+3] <= DataIn[7:0];
        end
    end
endmodule
