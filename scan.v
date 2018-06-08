`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/12 18:58:13
// Design Name: 
// Module Name: scan
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


module scan(EN_in1,EN_in0,sdata);

output [1:0] sdata;
input  EN_in1;
input  EN_in0;

reg [1:0] sdata;
wire EN_in;

assign EN_in = EN_in1 | EN_in0;

always @(posedge EN_in)
begin
	sdata <= sdata + 2'b01;
end
endmodule

