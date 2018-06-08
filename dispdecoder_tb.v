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

module dispdecoder_tb();
reg [3:0]data_in;
wire [7:0]data_out;
initial
begin
data_in<=4'b0000;
end
always #5 data_in<=data_in+1;
dispdecoder
dispdecoder(.data_in(data_in),.data_out(data_out));
endmodule