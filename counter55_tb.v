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

module counter55_tb;
reg [1:0]counter_light,speed_select;
reg [2:0]flowspeed;
wire C_out;
wire [3:0]D_OUT1,D_OUT0;
reg [7:0]data;
reg C_CLK;
reg RST;
reg C_EN;
initial
begin
C_CLK<=0;
data<=8'b00100010;
flowspeed<=3'b001;
counter_light<=2'b01;
speed_select<=2'b01;
#5 speed_select<=speed_select+1;
#5 counter_light<=counter_light+1;
#5 data<=8'b00110011;
end
always #5 C_CLK<=~C_CLK;
counter55
counter55_inst(.count_light(count_light),.speed_select(speed_select),
.flowspeed(flowspeed),.C_out(C_out),.D_OUT1(D_OUT1),.D_OUT0(D_OUT0),
.data(data),.C_CLK(C_CLK),.RST(RST),.C_EN(C_EN));
endmodule