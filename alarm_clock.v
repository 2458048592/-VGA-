`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/31 16:22:26
// Design Name: 
// Module Name: alarm_clock
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


module alarm_clock(input [2:0]flowspeed,input [1:0]count_light,input [1:0]count_light1,input Rst,input I_CLK,output reg O_CLK,output reg num);
reg [27:0]cnt;
parameter N=50000000;
reg [27:0]cnt1_0;
wire [1:0]accept,hope;
assign accept=count_light;
assign hope=count_light1;
always@(flowspeed)
begin
if(flowspeed==3'b000)
begin
cnt1_0<=50000000;
end
else if(flowspeed==3'b001)
begin cnt1_0<=25000000;end
else if(flowspeed==3'b011||flowspeed==3'b111)
begin
cnt1_0<=12500000;
end
end


always@(posedge I_CLK)
begin
if(Rst==0)
begin
cnt<=0;
O_CLK<=0;
end
else
begin
if(cnt==cnt1_0/2-1)
 begin O_CLK <= !O_CLK; cnt<=0; end
else
cnt <= cnt + 1;
end
end

always@(posedge O_CLK)
if(Rst==0)
num<=0;
else if(accept==hope&&flowspeed>3'b000)
begin
num<=~num;
end
else
num<=0;
endmodule

