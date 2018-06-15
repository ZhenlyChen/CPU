`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/17 23:30:01
// Design Name: 
// Module Name: Basys3
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


module Basys3(
    input clk,
    input nReset,
    input SW0,
    input SW1,
    input SW2,
    output [3:0] display_data,
    output [7:0] dispcode
    );
    
    wire clkCPU;
    
    wire [31:0] pc;
    wire [31:0] pc4;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [31:0] rsData;
    wire [31:0] rtData;
    wire [31:0] ALURes;
    wire [31:0] DB;
    
    BtnInOut BtnInOut( // 按钮消抖模块
        .clk(clk),
        .in(SW0),
        .out(clkCPU));
    
    S_CPU S_CPU(  // CPU模块
        .clk(clkCPU),
        .nReset(nReset), 
        .pc(pc),
        .pcIn(pc4),
        .rs(rs), 
        .rt(rt), 
        .ReadData1(rsData), 
        .ReadData2(rtData), 
        .ALURes(ALURes), 
        .writeData(DB));
        
     Display Display(  // 显示模块
        .clk(clk),
        .SW1(SW1),
        .SW2(SW2),
        .pc(pc),
        .pc4(pc4),
        .rs(rs),
        .rsData(rsData),
        .rt(rt),
        .rtData(rtData),
        .ALURes(ALURes),
        .DB(DB),
        .disp(display_data),
        .data(dispcode));
        
endmodule
