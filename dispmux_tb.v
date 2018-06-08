`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/31 14:15:15
// Design Name: 
// Module Name: dispmux_tb
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


module dispmux_tb;
reg [3:0]D_IN1,D_IN0;
reg [1:0]SEL;
wire [3:0] D_OUT;
initial
begin
D_IN1<=4'b0000;
D_IN0<=4'b0001;
SEL<=2'b00;
end
always #5 begin D_IN1<=D_IN1+1;D_IN0<=D_IN0+1;SEL<=SEL+1; end
dispmux
dispmux_inst(.D_IN1(D_IN1),.D_IN0(D_IN0),.SEL(SEL),.D_OUT(D_OUT));
endmodule
