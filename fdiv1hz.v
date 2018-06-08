`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/12 18:59:21
// Design Name: 
// Module Name: fdiv1hz
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


module fdiv1hz(clk_in,clk_out);

output clk_out;
input  clk_in;
reg clk_out;

integer cnt=0;

always @(posedge clk_in)
begin
	if(cnt<999) //实际系统的分频值
	//if(cnt<9)    //仿真时采用的分频值
	  begin
		cnt = cnt + 1;
		clk_out <= 1'b0;
	  end
	else
	  begin
	    cnt = 0;
		clk_out <= 1'b1;
	  end
end
endmodule
