`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/09 18:44:54
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
    input [31:0] Address,
    input [31:0] DataIn, // [31:24], [23:16], [15:8], [7:0]
    input mRD, // Ϊ 1����������Ϊ 0,�������̬
    input mWR, // Ϊ 1��д��Ϊ 0���޲���
    output [31:0] DataOut
    );
    reg [7:0] ram [0:60]; //�洢��
    
    // ��
    assign DataOut[7:0] = (mRD == 1)?ram[Address + 3]:8'bz; // z Ϊ����̬
    assign DataOut[15:8] = (mRD == 1)?ram[Address + 2]:8'bz;
    assign DataOut[23:16] = (mRD == 1)?ram[Address + 1]:8'bz;
    assign DataOut[31:24] = (mRD == 1)?ram[Address ]:8'bz;
    
    // д
    always@(mWR) begin
        if(mWR == 1) begin
            ram[Address] <= DataIn[31:24];
            ram[Address+1] <= DataIn[23:16];
            ram[Address+2] <= DataIn[15:8];
            ram[Address+3] <= DataIn[7:0];
        end
    end
endmodule