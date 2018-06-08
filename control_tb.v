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


module control_tb();
wire Red1;
wire Red2;
wire Yellow1;
wire Yellow2;
wire Green1;
wire Green2;

reg  [1:0] EN_in;
reg  SW1;
reg  RST;
initial
begin
EN_in<=2'b01;
SW1<=1;
RST<=1;
end
always #5 begin EN_in<=EN_in+1;RST<=~RST;end
control
control_inst(.Red1(Red1),.Red2(Red2),.Yellow1(Yellow1),.Yellow2(Yellow2),
.Green1(Green1),.Green2(Green2),.EN_in(EN_in),.SW1(SW1),.RST(RST));
endmodule
