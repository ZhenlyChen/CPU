`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/18 15:46:32
// Design Name: 
// Module Name: BtnInOut
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


module BtnInOut(
    input clk, //采集时钟，40Hz
    input in, //按键输入信号
    output out //消抖后的输出信号
    );
    
    reg in1, in2, in3;
    reg [31:0] counter;
    reg sClk;
    
    assign out = in2 | in3;
    
    always@(posedge clk) begin
        counter = counter + 1;
        if (counter > 32'h000000ff) begin
            counter = 0;
            sClk = !sClk;
        end
    end
        
    always@(posedge sClk) begin
        in1 <= in;
        in2 <= in1;
        in3 <= in2;
    end
endmodule
