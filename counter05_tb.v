`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/31 14:12:35
// Design Name: 
// Module Name: control_tb
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

module counter05_tb();
wire C_out;
wire [3:0]D_OUT1,D_OUT0;
reg C_CLK;
reg RST;
reg C_EN;
initial
begin
C_CLK<=0;
RST<=1;
C_EN<=1;
#5 RST<=0;
#5 C_CLK<=1;
end
always #5 C_CLK<=~C_CLK;
counter05
counter05_inst(.C_CLK(C_CLK),.D_OUT1(D_OUT1),.D_OUT0(D_OUT0),.C_out(C_out),.RST(RST),.C_EN(C_EN));
endmodule