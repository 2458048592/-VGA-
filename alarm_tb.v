`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/01/01 21:50:29
// Design Name: 
// Module Name: alarm_tb
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


module alarm_tb;
reg [1:0]count_light;
reg [1:0]count_light1;
reg Rst;
reg I_CLK;
wire O_CLK;
wire num;
initial
begin
end
alarm_clock
alarm_clock_inst(.count_light(count_light),.count_light1(count_light1)
,.Rst(Rst),.I_CLK(I_CLK),.O_CLK(O_CLK),.num(num));
endmodule
