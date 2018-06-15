`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/16 13:23:49
// Design Name: 
// Module Name: cpu_test
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


module cpu_test;
// input
reg clk;
reg nReset;
// output
wire [31:0] pc;
wire [31:0] ALURes;
wire [31:0] pc4;
wire [4:0] rs;
wire [4:0] rt;
wire [31:0] ReadData1;
wire [31:0] ReadData2;
wire [31:0] writeData;

S_CPU S_CPU(
    .clk(clk),
    .nReset(nReset), 
    .pc(pc), 
    .pcIn(pc4), 
    .rs(rs), 
    .rt(rt), 
    .ReadData1(ReadData1), 
    .ReadData2(ReadData2), 
    .ALURes(ALURes), 
    .writeData(writeData));


always #15 clk = !clk;
initial begin
    clk = 0;
    nReset = 0;
    #100;
    nReset = 1;
end

endmodule
