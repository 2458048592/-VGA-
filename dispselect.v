`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/12 19:00:01
// Design Name: 
// Module Name: dispselect
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


module dispselect(CLK,D_OUT);

output [1:0] D_OUT;

input CLK;

reg [1:0] D_OUT;

always @(posedge CLK)
begin
	if(D_OUT < 2'b10)
		D_OUT <= D_OUT + 2'b01;
	else
		D_OUT <= 2'b01;
end
endmodule
