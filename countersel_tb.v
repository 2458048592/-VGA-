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

module countersel_tb();
reg [1:0]D_in;
wire D_OUT1,D_OUT0;
initial
begin
D_in<=2'b00;
end
always #5 D_in<=D_in+1;
countersel
countersel_inst(.D_in(D_in),.D_OUT1(D_OUT1),.D_OUT0(D_OUT0));
endmodule