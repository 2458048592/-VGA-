`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/31 14:31:25
// Design Name: 
// Module Name: scan_tb
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


module scan_tb;
wire [1:0] sdata;
reg  EN_in1;
reg  EN_in0;
initial
begin
EN_in1<=0;
EN_in0<=1;
#5 EN_in1<=~EN_in1;
#5 EN_in0<=~EN_in0;
end
scan
scan_inst(.sdata(sdata),.EN_in1(EN_in1),.EN_in0(EN_in0));
endmodule
