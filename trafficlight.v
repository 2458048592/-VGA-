`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/12 19:05:33
// Design Name: 
// Module Name: trafficlight
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

module trafficlight(
	Reset1,
	SW,
	CLK,
	count_en,
	flowspeed,
	speed_select,
	count_light_hope,
	Red1,
	Red2,
	Yellow1,
	Yellow2,
	Green1,
	Green2,
	SEG_Data,
	SEG_Sel,
	SEG_Sel_1,
	thr_color_1,
	thr_color_2,
	r,
	g,
	b,
	hs,
	vs,
	O_CLK,
	num
);
input count_en;
input	Reset1;
input [1:0]speed_select;
input	SW;
input	CLK;
wire [1:0]count_light1;
input [1:0]count_light_hope;
//input   turn_left_en_1,turn_left_en_2,turn_left_en_3,turn_left_en_4;
input [2:0]flowspeed;
output [2:0] r;   
output [2:0] g;    
output [1:0] b;    
output hs;
output vs; 
output	Red1;
output	Red2;
output	Yellow1;
output	Yellow2;
output	Green1;
output	Green2;
output	[7:0] SEG_Data;
output	[1:0] SEG_Sel;
output	[5:0] SEG_Sel_1;
output	reg [2:0] thr_color_1;
output	reg [2:0] thr_color_2;
output O_CLK,num;
reg [3:0]data_55_0,data_55_1;
wire Reset=~Reset1;
wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_19;
wire	SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_20;
wire	[1:0] SYNTHESIZED_WIRE_21;
wire	SYNTHESIZED_WIRE_7;
wire	[3:0] SYNTHESIZED_WIRE_9;
wire	[3:0] SYNTHESIZED_WIRE_10;
wire	[3:0] SYNTHESIZED_WIRE_11;
wire	[3:0] SYNTHESIZED_WIRE_12;
wire	[3:0] SYNTHESIZED_WIRE_14;
wire	[3:0] SYNTHESIZED_WIRE_15;
wire	[3:0] SYNTHESIZED_WIRE_16;
wire	[1:0] SYNTHESIZED_WIRE_17;
wire line_0,line_1,line2,line_3;
reg [1:0]count_light;
assign	SEG_Sel = SYNTHESIZED_WIRE_17;
assign  count_light1=count_light;

assign line_0=(count_light==2'b00)?1:0;
assign line_1=(count_light==2'b01)?1:0;
assign line_2=(count_light==2'b10)?1:0;
assign line_3=(count_light==2'b11)?1:0;


scan	b2v_inst(.EN_in1(SYNTHESIZED_WIRE_0),
.EN_in0(SYNTHESIZED_WIRE_1),.sdata(SYNTHESIZED_WIRE_21));

counter05	b2v_inst1(.C_CLK(SYNTHESIZED_WIRE_19),
.RST(Reset),.C_EN(SYNTHESIZED_WIRE_3),.C_out(SYNTHESIZED_WIRE_1),.D_OUT0(SYNTHESIZED_WIRE_11),.D_OUT1(SYNTHESIZED_WIRE_12));

fdiv1hz	b2v_inst11(.clk_in(SYNTHESIZED_WIRE_20),
.clk_out(SYNTHESIZED_WIRE_19));

fdiv1khz	b2v_inst12(.clk_in(CLK),
.clk_out(SYNTHESIZED_WIRE_20));

control	b2v_inst14(.SW1(SW),
.RST(Reset),.EN_in(SYNTHESIZED_WIRE_21),.Red1(Red1),.Red2(Red2),.Yellow1(Yellow1),.Yellow2(Yellow2),.Green1(Green1),.Green2(Green2));
reg [7:0]a[3:0];
reg [7:0]para[3:0];
always@(posedge CLK or posedge speed_select or posedge flowspeed)
begin
begin
if(speed_select==2'b01)
begin
if(flowspeed==3'b000)
begin
para[0]<=44;para[1]<=44;para[2]<=44;para[3]<=44;
a[0]<=8'b01000100;
a[1]<=8'b01000100;
a[2]<=8'b01000100;
a[3]<=8'b01000100;
end
else if(flowspeed==3'b001)
begin
para[0]<=33;para[1]<=55;para[2]<=33;para[3]<=33;
a[0]<=8'b00110011;
a[1]<=8'b01010101;
a[2]<=8'b00110011;
a[3]<=8'b00110011;
end
else if(flowspeed==3'b011||flowspeed==3'b111)
begin
para[0]<=22;para[1]<=66;para[2]<=22;para[3]<=22;
a[0]<=8'b00010001;
a[1]<=8'b01100110;
a[2]<=8'b00100010;
a[3]<=8'b00100010;
end
end


else if(speed_select==2'b10)
begin
if(flowspeed==3'b000)
begin
para[0]<=44;para[1]<=44;para[2]<=44;para[3]<=44;
a[0]<=8'b01000100;
a[1]<=8'b01000100;
a[2]<=8'b01000100;
a[3]<=8'b01000100;
end
else if(flowspeed==3'b001)
begin
para[0]<=33;para[1]<=33;para[2]<=55;para[3]<=33;
a[0]<=8'b00110011;
a[2]<=8'b01010101;
a[1]<=8'b00110011;
a[3]<=8'b00110011;
end
else if(flowspeed==3'b011||flowspeed==3'b111)
begin
para[0]<=22;para[2]<=66;para[1]<=22;para[3]<=22;
a[0]<=8'b00100010;
a[2]<=8'b01100110;
a[1]<=8'b00100010;
a[3]<=8'b00100010;
end
end
else if(speed_select==2'b11)
begin
if(flowspeed==3'b000)
begin
para[0]<=44;para[1]<=44;para[2]<=44;para[3]<=44;
a[0]<=8'b01000100;
a[1]<=8'b01000100;
a[2]<=8'b01000100;
a[3]<=8'b01000100;
end
else if(flowspeed==3'b001)
begin
para[0]<=33;para[1]<=33;para[3]<=55;para[2]<=33;
a[0]<=8'b00110011;
a[3]<=8'b01000100;
a[2]<=8'b00100010;
a[1]<=8'b00100010;
end
else if(flowspeed==3'b011||flowspeed==3'b111)
begin
para[0]<=22;para[3]<=66;para[2]<=22;para[1]<=22;
a[0]<=8'b01100110;
a[3]<=8'b00100010;
a[2]<=8'b00100010;
a[1]<=8'b00100010;
end
end
else if(speed_select==2'b00)
begin
if(flowspeed==3'b000)
begin


para[0]<=44;para[1]<=44;para[2]<=44;para[3]<=44;
a[0]<=8'b00110011;
a[1]<=8'b00110011;
a[2]<=8'b00110011;
a[3]<=8'b00110011;
end
else if(flowspeed==3'b001)
begin
para[0]<=55;para[1]<=33;para[2]<=33;para[3]<=33;
a[3]<=8'b00110011;
a[0]<=8'b01010101;
a[2]<=8'b00110011;
a[1]<=8'b00110011;
end
else if(flowspeed==3'b011||flowspeed==3'b111)
begin
para[1]<=22;para[0]<=66;para[2]<=22;para[3]<=22;
a[3]<=8'b00100010;
a[0]<=8'b01100110;
a[2]<=8'b00100010;
a[1]<=8'b00100010;
end
end

end
end
reg [9:0]da;
reg [2:0]count11111;
always@(posedge SYNTHESIZED_WIRE_19)
begin
if(Reset==0)
begin
 da<=0;
 count11111<=0;
end
else begin
 da<=da+1;
 if(da==para[0]+5)
  begin count11111<=count11111+1;end
 else if(da==para[0]+para[1]+10)
  begin count11111<=count11111+1;end
 else if(da==para[0]+para[1]+para[2]+15) 
  begin count11111<=count11111+1;end
 else if(da==para[0]+para[1]+para[2]+para[3]+20)
  begin count11111<=0;da<=0;end
end  
end

counter55	b2v_inst2(.C_CLK(SYNTHESIZED_WIRE_19),
.RST(Reset),.C_EN(SYNTHESIZED_WIRE_7),.C_out(SYNTHESIZED_WIRE_0),
.data1(a[flag111]),.a0(a[0]),.a1(a[1]),.a2(a[2]),.a3(a[3]),.D_OUT0(SYNTHESIZED_WIRE_9),
.D_OUT1(SYNTHESIZED_WIRE_10),.count_light(countlight),.speed_select(speed_select),
.flowspeed(flowspeed),.line_0(line_0),.line_1(line_1),.line_2(line_2),.line_3(line_3));

countersel	b2v_inst3(.D_IN(SYNTHESIZED_WIRE_21),
.D_OUT1(SYNTHESIZED_WIRE_7),.D_OUT0(SYNTHESIZED_WIRE_3));





datamux	b2v_inst6(.D_IN0(SYNTHESIZED_WIRE_9),
.D_IN1(SYNTHESIZED_WIRE_10),.D_IN2(SYNTHESIZED_WIRE_11),.D_IN3(SYNTHESIZED_WIRE_12),.SEL(SYNTHESIZED_WIRE_21),.D_OUT0(SYNTHESIZED_WIRE_15),.D_OUT1(SYNTHESIZED_WIRE_16));

dispdecoder	b2v_inst7(.data_in(SYNTHESIZED_WIRE_14),
.data_out(SEG_Data));

dispmux	b2v_inst8(.D_IN0(SYNTHESIZED_WIRE_15),
.D_IN1(SYNTHESIZED_WIRE_16),.SEL(SYNTHESIZED_WIRE_17),.D_OUT(SYNTHESIZED_WIRE_14));

dispselect	b2v_inst9(.CLK(SYNTHESIZED_WIRE_20),
.D_OUT(SYNTHESIZED_WIRE_17));
assign	SEG_Sel_1 =6'b111111;
reg [1:0]btn,btn2;

reg flag;
always@(posedge Green1 or posedge Green2 or negedge Reset or posedge CLK)
begin
if(Reset==0)
begin
 count_light<=2'b00;
 flag<=0;
end
else if(Green1==1&&Green2==0&&flag==0)begin
    if(count_light==2'b11)
    begin count_light<=2'b00;flag<=1;end
    else begin count_light<= count_light+2'b01;flag<=1;end
end
else if(Green1==0&&Green2==1&&flag==1)begin
    if(count_light==2'b11)
    begin count_light<=2'b00;flag<=0;end
    else begin count_light<= count_light+2'b01;flag<=0;end
  end
end
wire [1:0]count_light_alarm;
wire [1:0]count_light_VGA;
assign count_light_VGA[1]=(line_2==1||line_3==1)?1:0;
assign count_light_VGA[0]=(line_1==1||line_3==1)?1:0;

assign count_light_alarm=count_light_VGA;
always@(Red1,Yellow1,Green1)
begin
if(Red1==1)begin
 btn<=2'b00;
 thr_color_1<=3'b100; 
 end
else if(Yellow1==1)begin
 btn<=2'b01;
 thr_color_1<=3'b110;
  end
else if(Green1==1)begin
 btn<=2'b11;
 thr_color_1<=3'b010;
 end
end

always@(Red2,Yellow2,Green2)
begin
if(Red2==1)
begin
 thr_color_2<=3'b100;
 btn2<=2'b00;
 end
else if(Yellow2==1)begin
 btn2<=2'b01;
 thr_color_2<=3'b110;end
else if(Green2==1)begin
 btn2<=2'b11;
 thr_color_2<=3'b010;
 end
end
//VGA_protect
//VGA_protect_1();
//vga_display
//vga_display_1(.clk(CLK),.rst(Reset),.hsync(hs),.vsync(vs),.r(r),.g(g),.b(b));

alarm_clock
alarm_clock(.flowspeed(flowspeed),.I_CLK(CLK),.Rst(Reset),.count_light1(speed_select),.count_light(count_light_alarm),.O_CLK(O_CLK),.num(num));
vga_controller
vga_controller_1(.SW(SW),.clk(CLK),.rst(Reset),.btn(btn),.btn2(btn2),.flowspeed(flowspeed),.speed_select(speed_select),
.count_light(count_light_VGA),.count_55_0(SYNTHESIZED_WIRE_15),.count_55_1(SYNTHESIZED_WIRE_16),
.r1(r),.g1(g),.b1(b),.vs(vs),.hs(hs));

endmodule

