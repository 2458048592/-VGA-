`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/12 19:02:53
// Design Name: 
// Module Name: countersel
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



module countersel(D_IN,D_OUT1,D_OUT0);

output D_OUT1;
output D_OUT0;

input  [1:0] D_IN;

reg D_OUT1;
reg D_OUT0;

always
begin
	case(D_IN)
		2'b00 : {D_OUT1,D_OUT0} <= 2'b10;
		2'b01 : {D_OUT1,D_OUT0} <= 2'b01;
		2'b10 : {D_OUT1,D_OUT0} <= 2'b10;
		2'b11 : {D_OUT1,D_OUT0} <= 2'b01;
		default : {D_OUT1,D_OUT0} <= 2'b00;
	endcase
end
endmodule
