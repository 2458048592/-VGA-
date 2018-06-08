`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/01/01 21:38:29
// Design Name: 
// Module Name: vga_controller_tb
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


module vga_controller_tb;
reg clk;    
reg rst;    
reg [1:0]btn;
reg [1:0]btn2;
reg [1:0]count_light;
reg [2:0]flowspeed;
reg [1:0]speed_select;
reg [3:0]count_55_0;
reg [3:0]count_55_1;
wire [2:0] r;    
wire [2:0] g;    
wire [1:0] b;    
wire hs;    
wire vs; 
initial
begin
clk<=0;    
rst<=0;    
btn<=2'b00;
btn2<=2'b00;
count_light<=2'b01;
flowspeed<=3'b000;
speed_select<=2'b01;
count_55_0<=4'b0001;;
count_55_1<=4'b0010;
end
always #5 clk<=~clk;
vga_controller
vga_controller_inst(.clk(clk),.rst(rst),.btn(btn),.btn2(btn2),.count_light(count_light),
.flowspeed(flowspeed),.speed_select(speed_select),.count_55_0(count_55_0),.count_55_1(count_55_1),
.r(r),.g(g),.b(b),.hs(hs),.vs(vs));
endmodule
