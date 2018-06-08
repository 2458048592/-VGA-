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

module dispselect_tb();
wire [1:0] D_OUT;

reg CLK;
initial
begin
CLK<=1;
end
always #5 CLK<=~CLK;
dispselect
dispselect_inst(.D_OUT(D_OUT),.CLK(CLK));
endmodule