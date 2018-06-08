`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/12 18:57:26
// Design Name: 
// Module Name: counter55
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

module counter55(C_CLK,RST,C_EN,data,D_OUT1,D_OUT0,C_out);

output C_out;
output [3:0] D_OUT1;
output [3:0] D_OUT0;
input [7:0]data;
input  C_CLK;
input  RST;
input  C_EN;
reg [3:0]data_0,data_1;

reg [3:0] D_OUT1;
reg [3:0] D_OUT0;
reg C_out;
reg [3:0] CData1;
reg [3:0] CData0;
reg [7:0] DATA;
always
if(RST==0)
begin
data_0<=data[3:0];
data_1<=data[7:4];
end

always @(posedge C_CLK)
begin
	if(RST==1||C_EN==0)
	  begin 
		C_out <= 1'b0;
		CData1 <= 4'b0000;
		CData0 <= 4'b0000;
	  end
	else
	  begin
	    if(CData0 ==data_0 && CData1 == data_1)
		  begin
	    	CData1 <= 4'b0000;
	        CData0 <= 4'b0000;
	        C_out = 1'b1;
	      end		
		else if(CData0 != 4'b1001)
		  begin
			CData0 <= CData0 + 1;
			C_out <= 1'b0;
		  end
		else if(CData0 == 4'b1001 && CData1 != 4'b0110)
		  begin
			CData1 <= CData1 + 1;
			CData0 <= 4'b0000;
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
reg [7:0]data_reg;
always
begin
    data_reg={data_1[3:0],data_0[3:0]};
	DATA <= data_reg-((CData1<<4)+CData0);
	if(((DATA>>4)&4'b1111)>data_1)
		D_OUT1 <= (DATA>>4)&4'b1111-4'b1111;
	else
		D_OUT1 <= (DATA>>4)&4'b1111;
	if((DATA&4'b1111)>4'b1001)
		D_OUT0 <= (DATA&4'b1111)-4'b0110;
	else
		D_OUT0 <= DATA&4'b1111;
end

endmodule
