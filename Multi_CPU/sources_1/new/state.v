`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/09 19:27:13
// Design Name: 
// Module Name: state
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


module state(
    input CLK,
    input RST,
    input[5:0] Op,
    output reg[2:0] State
    );
    
    always@(posedge CLK) begin
        if (RST == 0) State = 3'b000;
        else begin
            case(State)
                3'b000: State = 3'b001;
                3'b001: begin
                    if (Op[5:3] == 3'b111) State = 3'b000;
                    else State = 3'b010;
                end
                3'b010: begin
                    if (Op[5:2] == 4'b1101) State = 3'b000;
                    else if (Op[5:2] == 4'b1100) State = 3'b100;
                    else State = 3'b011;
                end
                3'b011: State = 3'b000;
                3'b100: begin
                    if (Op[0] == 0) State = 3'b000;
                    else State = 3'b011;
                end
            endcase
        end
    end
endmodule
