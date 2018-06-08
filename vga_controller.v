
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/16 21:07:39
// Design Name: 
// Module Name: vga_controller
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


`timescale 1ns / 1ps    
        
    module vga_controller(
        input clk,    
        input rst,    
        input [1:0]btn,
        input [1:0]btn2,
        output reg [2:0] r,    
        output reg [2:0] g,    
        output reg [1:0] b,    
        output hs,    
        output vs    
        );    
        
        parameter UP_BOUND = 31;    
        parameter DOWN_BOUND = 510;    
        parameter LEFT_BOUND = 144;    
        parameter RIGHT_BOUND = 783;    
        
        reg h_speed[3:0], v_speed[3:0];    
        reg [9:0]up_pos[1:0],down_pos[1:0],left_pos[1:0],right_pos[1:0];    
        reg [9:0]black_line_up[3:0],black_line_down[3:0],black_line_left[3:0],black_line_right[3:0];
        wire pclk;    
        reg [1:0]count;    
        reg [9:0]hcount, vcount;
        reg [9:0]yellow_line_up[3:0],yellow_line_down[3:0],yellow_line_left[3:0],yellow_line_right[3:0]; 
        //reg [9:0]jiantou_juxing_up[7:0],jiantou_juxing_down[7:0],jiantou_juxing_left[7:0],jiantou_juxing_right[7:0];
        reg [9:0]down_car_position_up[4:0],down_car_position_down[4:0],down_car_position_left[4:0],down_car_position_right[4:0];
        reg [9:0]up_car_position_up[4:0],up_car_position_down[4:0],up_car_position_left[4:0],up_car_position_right[4:0];
        reg [9:0]left_car_position_up[4:0],left_car_position_down[4:0],left_car_position_left[4:0],left_car_position_right[4:0];
        reg [9:0]right_car_position_up[4:0],right_car_position_down[4:0],right_car_position_left[4:0],right_car_position_right[4:0];
        //reg [9:0]jiantou_sanjiao_up[7:0],jiantou_sanjiao_down[7:0],jiantou_sanjiao_left[7:0],jiantou_sanjiao_right[7:0];
       // reg [50:0]detail[50:0];
        // 获得像素时钟25MHz 
        reg [9:0]VGA_count_up[3:0],VGA_count_down[3:0],VGA_count_left[3:0],VGA_count_right[3:0];   
        reg [9:0]divide_line_up[3:0],divide_line_down[3:0],divide_line_left[3:0],divide_line_right[3:0];
       
        assign pclk = count[1]; 
        
        always @ (posedge clk)    
        begin
            if (rst)    
                count <= 0;    
            else    
                count <= count+1;    
        end    
            
        // 列计数与行同步    
        assign hs = (hcount < 96) ? 0 : 1;    
        always @ (posedge pclk or posedge rst)    
        begin    
            if (rst)    
                hcount <= 0;    
            else if (hcount == 799)    
                hcount <= 0;    
            else    
                hcount <= hcount+1;    
        end    
            
        // 行计数与场同步    
        assign vs = (vcount < 2) ? 0 : 1;    
        always @ (posedge pclk or posedge rst)    
        begin    
            if (rst)    
                vcount <= 0;    
            else if (hcount == 799) begin    
                if (vcount == 520)    
                    vcount <= 0;    
                else    
                    vcount <= vcount+1;    
            end    
            else    
                vcount <= vcount;    
        end    
            
        // 显示方块    
        always @ (posedge pclk or posedge rst)    
        begin    
                if (rst) 
                begin    
                r <= 0;    
                g <= 0;    
                b <= 0;    
                end    
                else begin
                if(vcount>=up_pos[0] && vcount<=down_pos[0]    
                && hcount>=left_pos[0] && hcount<=right_pos[0]&&btn==2'b00) 
                begin    
                r <= 3'b111;    
                g <= 3'b000;    
                b <= 2'b00;    
                end  
                else if(vcount>=up_pos[0] && vcount<=down_pos[0]    
                && hcount>=left_pos[0] && hcount<=right_pos[0]&&btn==2'b01) 
                begin    
                r <= 3'b111;    
                g <= 3'b111;    
                b <= 2'b00;    
                end 
                else if(vcount>=up_pos[0] && vcount<=down_pos[0]&& hcount>=left_pos[0] && hcount<=right_pos[0]&&btn==2'b11)
                begin    
                r <= 3'b000;    
                g <= 3'b111;    
                b <= 2'b00;    
                end                                                            
                else if(vcount>=up_pos[1] && vcount<=down_pos[1]&&hcount>=left_pos[1]&&hcount<=right_pos[1]&&btn2==2'b00)
                begin    
                r <= 3'b111;    
                g <= 3'b000;    
                b <= 2'b00;    
                end   
                else if(vcount>=up_pos[1]&&vcount<=down_pos[1]&&hcount>=left_pos[1]&&hcount<=right_pos[1]&&btn2==2'b01)
                begin    
                r <= 3'b111;    
                g <= 3'b111;    
                b <= 2'b00;    
                end
                else if(vcount>=up_pos[1]&&vcount<=down_pos[1]&&hcount>=left_pos[1]&&hcount<=right_pos[1]&&btn2==2'b11)
                begin    
                r <= 3'b000;    
                g <= 3'b111;    
                b <= 2'b00;      
                end                                                 
                else if(vcount>=black_line_up[0]&&vcount<=black_line_down[0]
                &&hcount>=black_line_left[0]&&hcount<=black_line_right[0]
                &&(hcount%10)<3&&btn==2'b00)
                begin
                r <= 3'b000;    
                g <= 3'b111;    
                b <= 2'b00; 
                end
                else if(vcount>=black_line_up[0]&&vcount<=black_line_down[0]
                &&hcount>=black_line_left[0]&&hcount<=black_line_right[0]
                &&(hcount%10)<3&&btn==2'b01)
                begin
                r <= 3'b111;    
                g <= 3'b111;    
                b <= 2'b00; 
                end
                else if(vcount>=black_line_up[0]&&vcount<=black_line_down[0]
                &&hcount>=black_line_left[0]&&hcount<=black_line_right[0]
                &&(hcount%10)<3&&btn==2'b11)
                begin
                r <= 3'b111;    
                g <= 3'b000;    
                b <= 2'b00; 
                end                  
                else if(vcount>=black_line_up[1]&&vcount<=black_line_down[1]
                &&hcount>=black_line_left[1]&&hcount<=black_line_right[1]
                &&(hcount%10)<3&&btn==2'b00)
                begin
                r <= 3'b000;    
                g <= 3'b111;    
                b <= 2'b00; 
                end
                else if(vcount>=black_line_up[1]&&vcount<=black_line_down[1]
                &&hcount>=black_line_left[1]&&hcount<=black_line_right[1]
                &&(hcount%10)<3&&btn==2'b01)
                begin
                r <= 3'b111;    
                g <= 3'b111;    
                b <= 2'b00; 
                end
                else if(vcount>=black_line_up[1]&&vcount<=black_line_down[1]
                &&hcount>=black_line_left[1]&&hcount<=black_line_right[1]
                &&(hcount%10)<3&&btn==2'b11)
                begin
                r <= 3'b111;    
                g <= 3'b000;    
                b <= 2'b00; 
                end
                else if(hcount>=black_line_left[2]&&hcount<=black_line_right[2]
                &&vcount>=black_line_up[2]
                &&(vcount%10)<3&&vcount<=black_line_down[2]&&btn2==2'b00)
                begin
                r <= 3'b000;    
                g <= 3'b111;    
                b <= 2'b00; 
                end
                else if(hcount>=black_line_left[2]&&hcount<=black_line_right[2]
                &&vcount>=black_line_up[2]
                &&(vcount%10)<3&&vcount<=black_line_down[2]&&btn2==2'b01)
                begin
                r <= 3'b111;    
                g <= 3'b111;    
                b <= 2'b00; 
                end
                else if(hcount>=black_line_left[2]&&hcount<=black_line_right[2]
                &&vcount>=black_line_up[2]
                &&(vcount%10)<3&&vcount<=black_line_down[2]&&btn2==2'b11)
                begin
                r <= 3'b111;    
                g <= 3'b000;    
                b <= 2'b00; 
                end                      
                else if(hcount>=black_line_left[3]&&hcount<=black_line_right[3]
                &&vcount>=black_line_up[3]
                &&(vcount%10)<3&&vcount<=black_line_down[3]&&btn2==2'b00)
                begin
                r <= 3'b000;    
                g <= 3'b111;    
                b <= 2'b00; 
                end
                else if(hcount>=black_line_left[3]&&hcount<=black_line_right[3]
                &&vcount>=black_line_up[3]
                &&(vcount%10)<3&&vcount<=black_line_down[3]&&btn2==2'b01)
                begin
                r <= 3'b111;    
                g <= 3'b111;    
                b <= 2'b00; 
                end
                else if(hcount>=black_line_left[3]&&hcount<=black_line_right[3]
                &&vcount>=black_line_up[3]
                &&(vcount%10)<3&&vcount<=black_line_down[3]&&btn2==2'b11)
                begin
                r <= 3'b111;    
                g <= 3'b000;    
                b <= 2'b00; 
                end                 
                else if(hcount>=yellow_line_left[0]&&hcount<=yellow_line_right[0]
                &&vcount>=yellow_line_up[0]&&vcount<=yellow_line_down[0])
                begin
                r <= 3'b111;    
                g <= 3'b111;    
                b <= 2'b00;                 
                end 
                else if(hcount>=yellow_line_left[2]&&hcount<=yellow_line_right[2]
                &&vcount>=yellow_line_up[2]&&vcount<=yellow_line_down[2])
                begin
                r <= 3'b111;    
                g <= 3'b111;    
                b <= 2'b00;                 
                end
                else if(hcount>=yellow_line_left[1]&&hcount<=yellow_line_right[1]
                &&vcount>=yellow_line_up[1]&&vcount<=yellow_line_down[1])
                begin
                r <= 3'b111;    
                g <= 3'b111;    
                b <= 2'b00;                 
                end  
                else if(hcount>=yellow_line_left[3]&&hcount<=yellow_line_right[3]
                &&vcount>=yellow_line_up[3]&&vcount<=yellow_line_down[3])
                begin
                r <= 3'b111;    
                g <= 3'b111;    
                b <= 2'b00;                 
                end
                else if((hcount>=down_car_position_left[0]&&hcount<=down_car_position_right[0]
                &&vcount>=down_car_position_up[0]&&vcount<=down_car_position_down[0])||
                (hcount>=down_car_position_left[1]&&hcount<=down_car_position_right[1]
                &&vcount>=down_car_position_up[1]&&vcount<=down_car_position_down[1])||
                (hcount>=down_car_position_left[2]&&hcount<=down_car_position_right[2]
                &&vcount>=down_car_position_up[2]&&vcount<=down_car_position_down[2])||
                (hcount>=down_car_position_left[3]&&hcount<=down_car_position_right[3]
                &&vcount>=down_car_position_up[3]&&vcount<=down_car_position_down[3])
                ||(hcount>=down_car_position_left[4]&&hcount<=down_car_position_right[4]
                &&vcount>=down_car_position_up[4]&&vcount<=down_car_position_down[4]))
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;
                end
                else if(hcount>=divide_line_left[0]&&hcount<=divide_line_right[0]
                &&vcount>=divide_line_up[0]&&vcount<=divide_line_down[0]&&(hcount%10<3)&&(hcount<230||hcount>700))
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;
                end
                else if(hcount>=divide_line_left[1]&&hcount<=divide_line_right[1]
                &&vcount>=divide_line_up[1]&&vcount<=divide_line_down[1]&&(hcount%10<3)&&(hcount<230||hcount>700))
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;
                end                
                else if(hcount>=divide_line_left[2]&&hcount<=divide_line_right[2]
                &&vcount>=divide_line_up[2]&&vcount<=divide_line_down[2]&&(vcount%10<3)&&(vcount<120||vcount>415))
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;
                end
                else if(hcount>=divide_line_left[3]&&hcount<=divide_line_right[3]
                &&vcount>=divide_line_up[3]&&vcount<=divide_line_down[3]&&(vcount%10<3)&&(vcount<120||vcount>415))
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;
                end                                
                else begin    
                r <= 3'b000;    
                g <= 3'b000;    
                b <= 2'b00;    
                end 
                end      
        end    
        // 每一帧动画之后根据速度值更新方块的位置    
        always @ (posedge vs or posedge rst)    
        begin        
            if (rst) 
            begin              
            down_car_position_up[0]<=418;
            down_car_position_down[0]<=421;
            down_car_position_left[0]<=588;
            down_car_position_right[0]<=591; 
            down_car_position_up[1]<=418;
            down_car_position_down[1]<=421;
            down_car_position_left[1]<=594;
            down_car_position_right[1]<=597;            
            down_car_position_up[2]<=418;
            down_car_position_down[2]<=421;
            down_car_position_left[2]<=560;
            down_car_position_right[2]<=563;
            down_car_position_up[3]<=418;
            down_car_position_down[3]<=421;
            down_car_position_left[3]<=566;
            down_car_position_right[3]<=569;                         
            down_car_position_up[4]<=418;
            down_car_position_down[4]<=421;
            down_car_position_left[4]<=572;
            down_car_position_right[4]<=575;
            up_pos[0] <= 430;    
            down_pos[0] <= 450;    
            left_pos[0] <= 430;    
            right_pos[0] <= 450;   
            up_pos[1] <= 225;    
            down_pos[1] <= 245;    
            left_pos[1] <= 703;    
            right_pos[1] <= 723;   
            black_line_up[0]<=405; 
            black_line_down[0]<=415;             
            black_line_left[0]<=15; 
            black_line_right[0]<=783;               
            black_line_up[1]<=120; 
            black_line_down[1]<=130;             
            black_line_left[1]<=15; 
            black_line_right[1]<=783;           
            black_line_up[2]<=15; 
            black_line_down[2]<=740;             
            black_line_left[2]<=230; 
            black_line_right[2]<=240;     
            black_line_up[3]<=15; 
            black_line_down[3]<=740;             
            black_line_left[3]<=700; 
            black_line_right[3]<=710;  
            yellow_line_up[0]<=282; 
            yellow_line_down[0]<=285;             
            yellow_line_left[0]<=15; 
            yellow_line_right[0]<=230;                 
            yellow_line_up[1]<=415; 
            yellow_line_down[1]<=480;             
            yellow_line_left[1]<=465; 
            yellow_line_right[1]<=468;                   
            yellow_line_up[2]<=282; 
            yellow_line_down[2]<=285;             
            yellow_line_left[2]<=710; 
            yellow_line_right[2]<=775;   
            yellow_line_up[3]<=15; 
            yellow_line_down[3]<=120;             
            yellow_line_left[3]<=465; 
            yellow_line_right[3]<=468; 
            
            divide_line_up[0]<=206;
            divide_line_down[0]<=209;
            divide_line_left[0]<=15;
            divide_line_right[0]<=783;
            divide_line_up[1]<=345;
            divide_line_down[1]<=348;
            divide_line_left[1]<=15;
            divide_line_right[1]<=783;
            divide_line_up[2]<=15;
            divide_line_down[2]<=783;
            divide_line_left[2]<=584;
            divide_line_right[2]<=587;
            divide_line_up[3]<=15;
            divide_line_down[3]<=783;
            divide_line_left[3]<=352;
            divide_line_right[3]<=355;                                   
                
            end 
            else if (down_car_position_up[0] == UP_BOUND)  
            begin
            down_car_position_up[0]<=418;
            down_car_position_down[0]<=421;
            down_car_position_left[0]<=588;
            down_car_position_right[0]<=591; 
            down_car_position_up[1]<=418;
            down_car_position_down[1]<=421;
            down_car_position_left[1]<=594;
            down_car_position_right[1]<=597;            
            down_car_position_up[2]<=418;
            down_car_position_down[2]<=421;
            down_car_position_left[2]<=560;
            down_car_position_right[2]<=563;
            down_car_position_up[3]<=418;
            down_car_position_down[3]<=421;
            down_car_position_left[3]<=566;
            down_car_position_right[3]<=569;                         
            down_car_position_up[4]<=418;
            down_car_position_down[4]<=421;
            down_car_position_left[4]<=572;
            down_car_position_right[4]<=575;

            end
            else if(btn==2'b11||((btn==2'b00||btn==2'b01)&&down_car_position_up[0]<black_line_up[0]))
            begin
            down_car_position_up[0]<=down_car_position_up[0]-1;
            down_car_position_down[0]<=down_car_position_down[0]-1;
            down_car_position_left[0]<=down_car_position_left[0];
            down_car_position_right[0]<=down_car_position_right[0];
            down_car_position_up[1]<=down_car_position_up[1]-1;
            down_car_position_down[1]<=down_car_position_down[1]-1;
            down_car_position_left[1]<=down_car_position_left[1];
            down_car_position_right[1]<=down_car_position_right[1];
            down_car_position_up[2]<=down_car_position_up[2]-1;
            down_car_position_down[2]<=down_car_position_down[2]-1;
            down_car_position_left[2]<=down_car_position_left[2];
            down_car_position_right[2]<=down_car_position_right[2];
            down_car_position_up[3]<=down_car_position_up[3]-1;
            down_car_position_down[3]<=down_car_position_down[3]-1;
            down_car_position_left[3]<=down_car_position_left[3];
            down_car_position_right[3]<=down_car_position_right[3];            
            down_car_position_up[4]<=down_car_position_up[4]-1;
            down_car_position_down[4]<=down_car_position_down[4]-1;
            down_car_position_left[4]<=down_car_position_left[4];
            down_car_position_right[4]<=down_car_position_right[4];                                    
            end          
        end

endmodule    