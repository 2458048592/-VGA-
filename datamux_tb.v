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

module datamux_tb();
wire [3:0] D_OUT1;
wire [3:0] D_OUT0;

reg [3:0] D_IN3;
reg [3:0] D_IN2;
reg [3:0] D_IN1;
reg [3:0] D_IN0;
reg [1:0] SEL;
initial
begin
D_IN0<=4'b0000;
D_IN1<=4'b0000;
D_IN2<=4'b0000;
D_IN3<=4'b0000;
SEL<=2'b01;
end
always #5 begin D_IN0<=D_IN0+1;D_IN1<=D_IN1+1;D_IN2<=D_IN2+1;D_IN3<=D_IN3+1;  end
datamux
datamux_inst(.D_OUT1(D_OUT1),.D_OUT0(D_OUT0),.D_IN3(D_IN3),.D_IN2(D_IN2),.D_IN1(D_IN1),.D_IN0(D_IN0),.SEL(SEL));
endmodule