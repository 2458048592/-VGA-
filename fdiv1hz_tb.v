`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/31 14:29:47
// Design Name: 
// Module Name: fdiv1hz_tb
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


module fdiv1hz_tb();
reg clk_in;
wire clk_out;
initial
begin
clk_in<=0;
end
always #5 clk_in<=~clk_in;
fdiv1hz
fdiv1hz_inst(.clk_in(clk_in),.clk_out(clk_out));
endmodule
