`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/12 18:56:48
// Design Name: 
// Module Name: counter05
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


module counter05(C_CLK,RST,C_EN,D_OUT1,D_OUT0,C_out);

output C_out;
output [3:0] D_OUT1;
output [3:0] D_OUT0;

input  C_CLK;
input  RST;
input  C_EN;

reg [3:0] D_OUT1;
reg [3:0] D_OUT0;
reg C_out;
reg [3:0] CData1;
reg [3:0] CData0;
reg [7:0] DATA;


always @(posedge C_CLK)
begin
	if(RST==0||C_EN==0)
	  begin 
		C_out <= 1'b0;
		CData1 <= 4'b0000;
		CData0 <= 4'b0000;
	  end
	else
	  begin
	    if(CData0 != 4'b0101)
		  begin
			CData0 <= CData0 + 1;
			C_out <= 1'b0;
		  end
		else
	      begin
	    	CData1 <= 4'b0000;
	        CData0 <= 4'b0000;
	        C_out = 1'b1;
	      end
	end
end

always
begin
	DATA <= 8'b00000101-((CData1<<4)+CData0);
	D_OUT1 <= 4'b0000;	
	if((DATA&4'b1111)>4'b0101)
		D_OUT0 <= DATA&4'b1111-4'b1011;
	else
		D_OUT0 <= DATA&4'b1111;
end

endmodule