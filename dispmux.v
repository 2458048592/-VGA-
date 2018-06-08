`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/12 19:00:35
// Design Name: 
// Module Name: dispmux
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



module dispmux(SEL,D_IN1,D_IN0,D_OUT);

output [3:0] D_OUT;

input [3:0] D_IN1;
input [3:0] D_IN0;
input [1:0] SEL;

reg [3:0] D_OUT;

always
begin
	case(SEL)
		2'b01 : D_OUT <= D_IN0;
		2'b10 : D_OUT <= D_IN1;
		default : D_OUT <= 4'b0000;
	endcase	
end
endmodule
