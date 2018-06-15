`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/09 18:45:14
// Design Name: 
// Module Name: ROM
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



module ROM ( // �洢��ģ��
    input InsMemRw, // ��ʹ���ź�
    input [31:0] addr,// �洢����ַ
    output reg [31:0] dataOut);  // ��������� 
    reg [7:0] rom[99:0]; // �洢�����������reg���ͣ��洢���洢��Ԫ8λ���ȣ���100���洢��Ԫ
    
    initial begin     // �������ݵ��洢��rom��ע�⣺����ʹ�þ���·�����磺E:/Xlinx/VivadoProject/ROM/���Լ�����
        $readmemb ("C:/Users/Zhenly/OneDrive/Coding/Vivado/Multi_CPU/res.txt", rom);  // �����ļ�rom_data��.coe��.txt����δָ�����ʹ�0��ַ��ʼ��š�
    end
    
    always@(InsMemRw or addr) begin  
        if (InsMemRw == 1) begin          // Ϊ1�����洢����������ݴ洢ģʽ
           dataOut[31:24] = rom[addr]; 
           dataOut[23:16] = rom[addr+1]; 
           dataOut[15:8] = rom[addr+2]; 
           dataOut[7:0] = rom[addr+3]; 
        end
    end
endmodule
