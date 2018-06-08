`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/12 19:02:07
// Design Name: 
// Module Name: datamux
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


module datamux(D_IN3,D_IN2,D_IN1,D_IN0,SEL,D_OUT1,D_OUT0);

output [3:0] D_OUT1;
output [3:0] D_OUT0;

input [3:0] D_IN3;
input [3:0] D_IN2;
input [3:0] D_IN1;
input [3:0] D_IN0;
input [1:0] SEL;

reg [3:0] D_OUT1;
reg [3:0] D_OUT0;

always
begin
	case(SEL)
		2'b00 : begin 
		        	D_OUT0 <= D_IN0;D_OUT1 <= D_IN1;
				end
		2'b01 : begin 
		        	D_OUT0 <= D_IN2;D_OUT1 <= D_IN3;
		        end
		2'b10 : begin 
		        	D_OUT0 <= D_IN0;D_OUT1 <= D_IN1;
				end
		2'b11 : begin 
		        	D_OUT0 <= D_IN2;D_OUT1 <= D_IN3;
		        end
		default : begin
		          	D_OUT0 <= 4'b0000;D_OUT1 <= 4'b0000;
				  end
	endcase
end
endmodule
