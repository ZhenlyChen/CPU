`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/18 10:09:12
// Design Name: 
// Module Name: Display
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


module Display(
    input clk,
    input SW1,
    input SW2,
    input [31:0] pc,
    input [31:0] pc4,
    input [4:0] rs,
    input [31:0] rsData,
    input [4:0] rt,
    input [31:0] rtData,
    input [31:0] ALURes,
    input [31:0] DB,
    output reg [3:0] disp,
    output [7:0] data
    );
    reg [15:0] displayData;
    reg [3:0] displayNow;
    reg [31:0] counter;
    reg [2:0] dispCounter;
    reg sClk;
    
    always@(posedge clk) begin
        counter = counter + 1;
        if (counter > 32'h0000ffff) begin
            counter = 0;
            sClk = !sClk;
        end
    end
    
    always@(SW1 or SW2 or pc or pc4 or rs or rt or rsData or rtData or ALURes or DB) begin
        case({SW1, SW2})
            2'b00: displayData = {pc[7:0], pc4[7:0]};
            2'b01: displayData = {3'b000, rs, rsData[7:0]};
            2'b10: displayData = {3'b000, rt, rtData[7:0]};
            2'b11: displayData = {ALURes[7:0], DB[7:0]};
        endcase
    end
    
    always@(posedge sClk) begin
        dispCounter = dispCounter + 1;
        if (dispCounter > 4) dispCounter = 0;
        case(dispCounter)
            2'b00: begin
                disp = 4'b0111;
                displayNow = displayData[15:12];
            end
            2'b01: begin
                disp = 4'b1011;
                displayNow = displayData[11:8];
            end
            2'b10: begin
                disp = 4'b1101;
                displayNow = displayData[7:4];
            end
            2'b11: begin
                disp = 4'b1110;
                displayNow = displayData[3:0];
            end
        endcase
    end
    
    SegLED SegLED(
        .display_data(displayNow),
        .dispcode(data));
    
endmodule
