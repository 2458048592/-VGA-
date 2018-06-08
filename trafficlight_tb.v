`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/12 19:38:05
// Design Name: 
// Module Name: trafficlight_tb
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


module trafficlight_tb;
reg  count_en;
reg Reset1;
reg  [1:0]speed_select;
reg SW;
reg CLK;
reg  [1:0]count_light_hope;
//input   turn_left_en_1,turn_left_en_2,turn_left_en_3,turn_left_en_4;
reg  [2:0]flowspeed;
wire [2:0] r;   
wire [2:0] g;    
wire [1:0] b;    
wire hs;
wire vs; 
wire Red1;
wire Red2;
wire Yellow1;
wire Yellow2;
wire Green1;
wire Green2;
wire [7:0] SEG_Data;
wire [1:0] SEG_Sel;
wire [5:0] SEG_Sel_1;
wire [2:0] thr_color_1;
wire [2:0] thr_color_2;
wire O_CLK,num;
initial
begin
count_en<=1;
Reset1<=0;
CLK<=1;
speed_select<=2'b01;
count_light_hope<=2'b01;
SW<=1;
flowspeed<=3'b001;
#5 SW<=0;
#5 Reset1<=1;
#5 Reset1<=0;
end
always #5 CLK<=~CLK;
trafficlight
trafficlight_inst(.count_en(count_en),.Reset1(Reset1),.CLK(CLK),.SW(SW),.flowspeed(flowspeed),
.count_light_hope(count_light_hope),.speed_select(speed_select),
.O_CLK(O_CLK),.num(num),.thr_color_2(thr_color_2),.thr_color_1(thr_color_1),
.SEG_Sel_1(SEG_Sel_1),.SEG_Sel(SEG_Sel),.SEG_Data(SEG_Data),.Green2(Green2),
.Green1(Green1),.Yellow2(Yellow2),.Yellow1(Yellow1),.Red2(Red2),.Red1(Red1),.hs(hs),
.vs(vs),.r(r),.g(g),.b(b));
endmodule
