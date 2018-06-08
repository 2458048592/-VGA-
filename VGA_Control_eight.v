
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
        input SW,
        input clk,    
        input rst,    
        input [1:0]btn,
        input [1:0]btn2,
        input [1:0]count_light,
        input [2:0]flowspeed,
        input [1:0]speed_select,
        input [3:0]count_55_0,
        input [3:0]count_55_1,
        output [2:0] r1,    
        output [2:0] g1,    
        output [1:0] b1,    
        output hs,    
        output vs    
        );
        reg [2:0]r,g;
        reg [1:0]b;  
        reg [2:0]r2,g2;
        reg [1:0]b2; 
        assign r1=(rst==1)?r:r2; 
        assign g1=(rst==1)?g:g2;
        assign b1=(rst==1)?b:b2;    
        parameter UP_BOUND = 31;    
        parameter DOWN_BOUND = 510;    
        parameter LEFT_BOUND = 144;    
        parameter RIGHT_BOUND = 783;
        reg [9:0]jiantou_up_position[7:0],jiantou_down_position[7:0],jiantou_left_position[7:0],jiantou_right_position[7:0];        
        reg [10:0]jiantou_down_left[10:0],jiantou_down_right[10:0],jiantou_down_up[10:0],jiantou_down_down[10:0];
        reg [19:0]jiantou_double_left[16:0],jiantou_double_right[16:0],jiantou_double_up[16:0],jiantou_double_down[16:0];
        reg [19:0]jiantou_double_left1[16:0],jiantou_double_right1[16:0],jiantou_double_up1[16:0],jiantou_double_down1[16:0];   
        reg [9:0]up_pos[3:0],down_pos[3:0],left_pos[3:0],right_pos[3:0];    
        reg [9:0]black_line_up[3:0],black_line_down[3:0],black_line_left[3:0],black_line_right[3:0];
        wire pclk;    
        reg [1:0]count;    
        reg [9:0]hcount, vcount;
        reg [9:0]yellow_line_up[3:0],yellow_line_down[3:0],yellow_line_left[3:0],yellow_line_right[3:0]; 
        reg [9:0]down_car_position_up[4:0],down_car_position_down[4:0],down_car_position_left[4:0],down_car_position_right[4:0];
        reg [9:0]up_car_position_up[4:0],up_car_position_down[4:0],up_car_position_left[4:0],up_car_position_right[4:0];
        reg [9:0]left_car_position_up[4:0],left_car_position_down[4:0],left_car_position_left[4:0],left_car_position_right[4:0];
        reg [9:0]right_car_position_up[4:0],right_car_position_down[4:0],right_car_position_left[4:0],right_car_position_right[4:0];
        reg [9:0]VGA_count_up[3:0],VGA_count_down[3:0],VGA_count_left[3:0],VGA_count_right[3:0];   
        reg [9:0]divide_line_up[3:0],divide_line_down[3:0],divide_line_left[3:0],divide_line_right[3:0];
        reg [9:0]car_turn_right_up[3:0],car_turn_right_down[3:0],car_turn_right_left[3:0],car_turn_right_right[3:0];
        reg [9:0]car_turn_left_up[3:0],car_turn_left_down[3:0],car_turn_left_left[3:0],car_turn_left_right[3:0];
        assign pclk = count[1]; 
        reg [9:0]shuzi_up,shuzi_down,shuzi_left,shuzi_right;
        reg [19:0]count_left[19:0],count_right[19:0];
        reg [3:0]speed[2:0];
        reg [9:0]VGA_protect_up,VGA_protect_left;
        always @ (posedge clk)    
        begin
            if (rst==0)    
                count <= 0;    
            else    
                count <= count+1;    
        end
        
        wire pclk1;        
        reg [1:0]count1;
        assign pclk1=count1[1];
        always @ (posedge clk)    
        begin
            if (rst==1)    
                count1 <= 0;    
            else    
                count1 <= count1+1;    
        end
   
        wire hs1,hs0;
        wire vs1,vs0;        
        assign vs=(rst==1)?vs0:vs1;   
        assign hs=(rst==1)?hs0:hs1; 
        reg [9:0]hcount1,vcount1;   
        // 列计数与行同步    
        assign hs0 = (hcount < 96) ? 0 : 1;    
        always @ (posedge pclk or posedge rst)    
        begin    
            if (rst==0)    
                hcount <= 0;    
            else if (hcount == 799)    
                hcount <= 0;    
            else    
                hcount <= hcount+1;    
        end    
            
        // 行计数与场同步    
        assign vs0 = (vcount < 2) ? 0 : 1;    
        always @ (posedge pclk or posedge rst)    
        begin    
            if (rst==0)    
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
        
        
        assign hs1 = (hcount1 < 96) ? 0 : 1;    
        always @ (posedge pclk1 or posedge rst or negedge rst)    
        begin    
            if (rst==1)    
                hcount1 <= 0;    
            else if (hcount1 == 799)    
                hcount1 <= 0;    
            else    
                hcount1 <= hcount1+1;    
        end    
            
        // 行计数与场同步    
        assign vs1 = (vcount1 < 2) ? 0 : 1;    
        always @ (posedge pclk1 or posedge rst or negedge rst)    
        begin    
            if (rst==1)    
                vcount1 <= 0;    
            else if (hcount1 == 799) begin    
                if (vcount1 == 520)    
                    vcount1 <= 0;    
                else    
                    vcount1 <= vcount1+1;    
            end    
            else    
                vcount1 <= vcount1;    
        end         
        
        reg [95:0]made[28:0];
        reg [47:0]by[47:0];
        reg [47:0]tu[47:0];
        reg [47:0]yuan[47:0];
        reg [47:0]peng[47:0];
        // 显示方块
        reg [9:0]made_left,made_up;reg [9:0]by_left,by_up;reg [9:0]tu_left,tu_up;
        reg [9:0]yuan_left,yuan_up;reg [9:0]peng_left,peng_up;
        reg [31:0]walk_people[24:0]; reg [9:0]car_straight_up[3:0],car_straight_left[3:0];
        reg [47:0]central[47:0];     reg [9:0]car_leftturn_up[3:0],car_leftturn_left[3:0];
        reg [28:0]car[28:0];
        reg [479:0]VGA_protect[47:0];
        reg [19:0]display_jiantou_down[19:0],display_jiantou_right[19:0]; 
        always@(posedge rst or negedge rst)
        begin
        if(rst==0)
        begin
        made[0]<=96'h000000000000000000000000;
        made[1]<=96'h000000000000000000000000;
        made[2]<=96'h000000000000000000000000;
        made[3]<=96'h000000000000000000000000;
        made[4]<=96'h000000000000000000000000;
        made[5]<=96'h000000000000000000000000;
        made[6]<=96'h000000000000000000000000;
        made[7]<=96'h000000000000000000000000;
        made[8]<=96'h000000000000000000000000;
        made[9]<=96'h000000000000000000000000;
        made[10]<=96'h03e000f8000000001e000000;
        made[11]<=96'h03f000f8000000001e000000;
        made[12]<=96'h03f001f8000000001e000000;
        made[13]<=96'h03f001fc000000001e000000;
        made[14]<=96'h03f001fc000000001e000000;
        made[15]<=96'h03f803fc000000001e000000;
        made[16]<=96'h07b803bc000000001e000000;
        made[17]<=96'h07b803bc000000001e000000;
        made[18]<=96'h07bc07bc03f8000e1e003c00;
        made[19]<=96'h07bc073c1ffe003fde01ff80;
        made[20]<=96'h079c073c0fff007ffe03ffc0;
        made[21]<=96'h079e0f3c0c0f80f87e0783c0;
        made[22]<=96'h079e0f3c000781f03e0701e0;
        made[23]<=96'h079e0e3c0003c1e03e0f00e0;
        made[24]<=96'h078f0e3c0003c1e01e0e00f0;
        made[25]<=96'h078f1e3c007fc3c01e1e00f0;
        made[26]<=96'h078f1c3c03ffc3c01e1ffff0;
        made[27]<=96'h07071c3c07ffc3c01e1ffff0;
        made[28]<=96'h0707bc3c0f83c3c01e1ffff0;
        by[0]<=48'h000000000000;
        by[1]<=48'h000000000000;
        by[2]<=48'h000000000000;
        by[3]<=48'h000000000000;
        by[4]<=48'h000000000000;
        by[5]<=48'h000000000000;
        by[6]<=48'h000000000000;
        by[7]<=48'h000000000000;
        by[8]<=48'h001fe0000000;
        by[9]<=48'h007ffc000000;
        by[10]<=48'h007ffe000000;
        by[11]<=48'h00783f000000;
        by[12]<=48'h00780f000000;
        by[13]<=48'h007807800000;
        by[14]<=48'h007807800000;
        by[15]<=48'h007807800000;
        by[16]<=48'h0078079f00f8;
        by[17]<=48'h0078070f00f0;
        by[18]<=48'h00780f0f00f0;
        by[19]<=48'h00783e0f80f0;
        by[20]<=48'h007ffc0781e0;
        by[21]<=48'h007ff80781e0;
        by[22]<=48'h007ffe07c1e0;
        by[23]<=48'h00781f03c3c0;
        by[24]<=48'h00780f83c3c0;
        by[25]<=48'h007807c1e3c0;
        by[26]<=48'h007803c1e380;
        by[27]<=48'h007803c1e780;
        by[28]<=48'h007803c0f780;
        by[29]<=48'h007803c0f700;
        by[30]<=48'h007807c0f700;
        by[31]<=48'h00780f807f00;
        by[32]<=48'h00783f807e00;
        by[33]<=48'h007fff003e00;
        by[34]<=48'h007ffc003c00;
        by[35]<=48'h007fe0003c00;
        by[36]<=48'h000000003c00;
        by[37]<=48'h000000007800;
        by[38]<=48'h00000000f800;
        by[39]<=48'h00000001f000;
        by[40]<=48'h00000003e000;
        by[41]<=48'h0000000fe000;
        by[42]<=48'h00000007c000;;
        by[43]<=48'h000000070000;;
        by[44]<=48'h000000040000;
        by[45]<=48'h000000000000;
        by[46]<=48'h000000000000;
        by[47]<=48'h000000000000 ;
        tu[0]<=48'h000000000000;tu[1]<=48'h000000000000;
        tu[2]<=48'h000000000000;tu[3]<=48'h000000000000;
        tu[4]<=48'h000000000000;tu[5]<=48'h000000000000;
        tu[6]<=48'h000000000000;tu[7]<=48'h000000000000;
        tu[8]<=48'h000000400000;tu[9]<=48'h000000fc0000;
        tu[10]<=48'h002000f80000;tu[11]<=48'h003800f80000;
        tu[12]<=48'h007c01fc0000;tu[13]<=48'h003f03ce0000;
        tu[14]<=48'h001f03c70000;tu[15]<=48'h000607878000;
        tu[16]<=48'h00020f03c000;tu[17]<=48'h00001f01f000;
        tu[18]<=48'h00001e00fc00;tu[19]<=48'h00807c007f00;
        tu[20]<=48'h01f0ffff9e00;tu[21]<=48'h01fdf7ff8c00;
        tu[22]<=48'h0078e0380000;tu[23]<=48'h001840380000;
        tu[24]<=48'h000000380000;tu[25]<=48'h000000380000;
        tu[26]<=48'h0000fffffc00;tu[27]<=48'h0010fffffc00;
        tu[28]<=48'h001800380000;tu[29]<=48'h003c00380000;
        tu[30]<=48'h003818384000;tu[31]<=48'h00383f39e000;
        tu[32]<=48'h00383c38f000;tu[33]<=48'h007878387800;
        tu[34]<=48'h007070387c00;tu[35]<=48'h0070f0383e00;
        tu[36]<=48'h00f1e0381c00;tu[37]<=48'h00f3c3f80800;
        tu[38]<=48'h00f081f80000;tu[39]<=48'h002001f00000;
        tu[40]<=48'h000000800000;tu[41]<=48'h000000000000;
        tu[42]<=48'h000000000000;tu[43]<=48'h000000000000;
        tu[44]<=48'h000000000000;tu[45]<=48'h000000000000;
        tu[46]<=48'h000000000000;tu[47]<=48'h000000000000;
        
        yuan[0]<=48'h000000000000;        yuan[1]<=48'h000000000000;
        yuan[2]<=48'h000000000000;        yuan[3]<=48'h000000000000;
        yuan[4]<=48'h000000000000;;        yuan[5]<=48'h000000000000;
        yuan[6]<=48'h000000000000;        yuan[7]<=48'h000000000000;
        yuan[8]<=48'h000000000000;        yuan[9]<=48'h000400000000;
        yuan[10]<=48'h001e00000000;        yuan[11]<=48'h001e0ffff000;
        yuan[12]<=48'h000e0ffff000;        yuan[13]<=48'h000f00000000;
        yuan[14]<=48'h000f00000000;        yuan[15]<=48'h000c00000000;
        yuan[16]<=48'h000000000000;        yuan[17]<=48'h000000000000;
        yuan[18]<=48'h00003ffffe00;        yuan[19]<=48'h00003ffffe00;
        yuan[20]<=48'h00fe01c70000;
        yuan[21]<=48'h00fe01c70000;;
        yuan[22]<=48'h00fe01c70000;
        yuan[23]<=48'h000e01c70000;
        yuan[24]<=48'h000e01c70000;
        yuan[25]<=48'h000e03c70000;
        yuan[26]<=48'h000e03870000;
        yuan[27]<=48'h000e03870800;
        yuan[28]<=48'h000e03870c00;
        yuan[29]<=48'h000e07070f00;
        yuan[30]<=48'h000e0f070e00;
        yuan[31]<=48'h000e1e071e00;
        yuan[32]<=48'h000e7c07fc00;
        yuan[33]<=48'h000e7803f800;
        yuan[34]<=48'h001f10000000;
        yuan[35]<=48'h003fc0000000;
        yuan[36]<=48'h007bf8000f00;
        yuan[37]<=48'h01f0ffffff00;
        yuan[38]<=48'h00e03ffffe00;
        yuan[39]<=48'h004007fffe00;
        yuan[40]<=48'h000000000000;
        yuan[41]<=48'h000000000000;
        yuan[42]<=48'h000000000000;        yuan[43]<=48'h000000000000;
        yuan[44]<=48'h000000000000;
        yuan[45]<=48'h000000000000;        yuan[46]<=48'h000000000000;        
        yuan[47]<=48'h000000000000;
        peng[0]=48'h000000000000;
        peng[1]=48'h000000000000;
        peng[2]=48'h000000000000;
        peng[3]=48'h000000000000;
        peng[4]=48'h000000000000;
        peng[5]=48'h000000000000;
        peng[6]=48'h000000000000;
        peng[7]=48'h000000000000;
        peng[8]=48'h00000000e000;
        peng[9]=48'h00000000c000;
        peng[10]=48'h003f8fe0c100;
        peng[11]=48'h003f8fe7fe00;
        peng[12]=48'h00318c67fe00;
        peng[13]=48'h00318c660e00;
        peng[14]=48'h00318c660e00;
        peng[15]=48'h00318c660e00;
        peng[16]=48'h00318c666e00;
        peng[17]=48'h00318c666e00;
        peng[18]=48'h003f8fe66e00;
        peng[19]=48'h003f8fe66e00;
        peng[20]=48'h00318c660c00;
        peng[21]=48'h00318c663c00;
        peng[22]=48'h00318c663800;
        peng[23]=48'h00318c660000;
        peng[24]=48'h00318c660000;
        peng[25]=48'h00318c660080;
        peng[26]=48'h003f8fe7ff80;
        peng[27]=48'h003f8fe7ff80;;
        peng[28]=48'h00318c600700;
        peng[29]=48'h00318c600700;
        peng[30]=48'h00718c600700;
        peng[31]=48'h0061987ff700;
        peng[32]=48'h0061987ff700;
        peng[33]=48'h006198600700;
        peng[34]=48'h006198600700;
        peng[35]=48'h00e198600700;
        peng[36]=48'h01cfb8600f00;
        peng[37]=48'h004713e07f00;
        peng[38]=48'h000011c07e00;
        peng[39]=48'h000000003800;
        peng[40]=48'h000000000000;
        peng[41]=48'h000000000000;
        peng[42]=48'h000000000000;
        peng[43]=48'h000000000000;
        peng[44]=48'h000000000000;
        peng[45]=48'h000000000000;
        peng[46]=48'h000000000000;
        peng[47]=48'h000000000000;
        VGA_protect[0]<=480'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
        VGA_protect[1]<=480'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
        VGA_protect[2]<=480'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
        VGA_protect[3]<=480'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
        VGA_protect[4]<=480'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
        VGA_protect[5]<=480'h000000000000000000000000000000000000000000000000000000000000000000000000000008000800000000000000000000000000000000000000;
        VGA_protect[6]<=480'h000000020000000000000000000280000000000000000000600000000000000000000000000005001600000000000000000000020000000030000000;        
        VGA_protect[7]<=480'h0000000d0000008004000000000200000000000004000001b000000000000000000000000000040008000000000000000000009100018000d0000000;
        VGA_protect[8]<=480'h00000006000005001a0000000004000000000000040000009800000606a08840003c0000000030002400000000000000000025520000a00030000000;
        VGA_protect[9]<=480'h00000009000000804d2498000003000002bb5a80080000001800000a052b67800078000000005224135500000ca3de0015b65ba90002400030000000;
        VGA_protect[10]<=480'h000000050000020050292000000400000332b50006000000b0000015029021400020000000002d6c08760000021f82003a9367348001c00050000000;
        VGA_protect[11]<=480'h0000001e0000010012a450000003000000a5a5800a00000068000000054eb600000000000000b250013102520bd119000d4599800002800050000000;
        VGA_protect[12]<=480'h005d5c080008008060102800ffe60360000000000a001d2125809001001814000018092ff202218021800263440202001002800000058052e40c0000;
        VGA_protect[13]<=480'h00009a0e004001a080283001ef44807c000c00030c0005016500b002c00c4800000006481a03c000404000180400050000076000000500adbd300000;
        VGA_protect[14]<=480'h0067282500900040e01808000092e00400010004020065f01a0040010002400000180003800001440080003008040300000400c00002009242cc0000;        
        VGA_protect[15]<=480'h000008120f4000804030100000020000000400010a00000000000000000e200000086000000000020100000802080400000a013000000a0100000000;
        VGA_protect[16]<=480'h0000123000c000004020280000040100000808050600000000400000000580000a08a003c0000002800000100408010000580190000a128120000000;
        VGA_protect[17]<=480'h0000044000400000402828000804008000340d02060000280060000001c9495002109003c005b2f77d5c001807579b00002005e000080c02c0000000;
        VGA_protect[18]<=480'h00000e1801a00000403828000c04034000000f010600000200d000000636ae200c298003c006cd559793000008984e0005954f000018040280000000;
        VGA_protect[19]<=480'h00181030000000004038280012040400002001830600003800c0000005c257e002040003c001a1aae97600300447a800042aa00000268c0001000000;
        VGA_protect[20]<=480'h000e004011c01980402828000000068000e0124006000048003a0000000080200c120003c00600000005000800040200034c34200010500c02800000;
        VGA_protect[21]<=480'h00091ca0c0000f80402828000e000d00019a6a07060001200025007e060200400c280003c002000000000000040804000200e0400020501202400000;
        VGA_protect[22]<=480'h0007092020001e404028280000041a00002594e006000240000a80000102002000280003c00102e79b8501b242060300000380900000200400c00000;        
        VGA_protect[23]<=480'h00041000800001004038280004070200012b000706000680000440ff03a9daa00a300003c002159d670104c584020500001100740001404888600000;
        VGA_protect[24]<=480'h0002100080000140e0081800000000000100000506001d000102a0af056b286004280003c0000200fd80026b480001000044002c0000406dd6a00000;
        VGA_protect[25]<=480'h0001a800200001c080303007859e52ff000380030600320c0081400405a2664014280003c0000400020000080099aa00039800130001003e10080000;
        VGA_protect[26]<=480'h000020004000018020202000b4f1adff0000800306002424036080020503800000300003c00004000280002007527d001e35d48a8006801008100000;
        VGA_protect[27]<=480'h0000d000a0000180c0181807432a517f0001000606001018020000050501004000100003c0000400000000180c35b20005db9c2d4009000410000000;
        VGA_protect[28]<=480'h0000000140000140270808000052a0000002800106000002054000040502806000480003c0000aff4d800018000c000002349382a00502011c000000;
        VGA_protect[29]<=480'h00007000500001c0d0ab68000093000001652e85060000050080000205e5496000220003c00008ff32000030000400000d0050018012a60404000000;
        VGA_protect[30]<=480'h00004400b80001009410400001643000002f91020600000809000001051ab24000080003c0000900c500002800080000000020000019920710000000;        
        VGA_protect[31]<=480'h00011800400001c1600090000043080001961604060000039600000705a5040000210003c00004000000002000040000004050000001400004000000; 
        VGA_protect[32]<=480'h00005900180001c0a010000003850000000000040a000001580000050201000000928002c000140000000028068aff00002060100000000618000000;
        VGA_protect[33]<=480'h00018a030c0001c0801000000c041800000380020e000002a4000002010200a000422003c00010000000000009bdff00018800480000000a0c000000;
        VGA_protect[34]<=480'h0002830214000000000800000a030b000002000508000001580000050501014000806802c00011005ec00021852d0000007060740000000410000000;        
        VGA_protect[35]<=480'h0006000d020000400030000030070a80000200000c000006d4000004010002c00040d801c0000dffb1000012c00200000700302a0000020a0c000000;
        VGA_protect[36]<=480'h001c001204c00528000000011804031400018440060000389220000b8503850003400001c0001c0000c00594000a00001000000a4008891004180000;
        VGA_protect[37]<=480'h0030002403200a8580002a04e00100e900d46980020000410b1800034000000002800000c000000000000490000600002c0020026021300410000000;
        VGA_protect[38]<=480'h0008005c0188021628a1980b00000002039690000800032a00b5a036e000002002800003c0001400014003806551ff4004004001c01c004818100000;
        VGA_protect[39]<=480'h0000003000301c014d684c04c006002a00e500000600bdd0004f4048128f39900d0000c4c00009ff5980040085a2ff00480b90008000012003280000;
        VGA_protect[40]<=480'h000002b0005008002dff8c020002000c0120000144004b20000d00200dffe0500e00000b800017ff5ac004000effff4000069000000005d00aa00000;
        VGA_protect[41]<=480'h0008056000001000520050030005000a0240000114002240003b004007fffe102200007c80000cff6d00040000000040100520010000023016180000;
        VGA_protect[42]<=480'h000001c000000800000000000003000400000000600006000002001000ffff8008000025000019ffb2400000000000000005c0000000024005400000;        
        VGA_protect[43]<=480'h000008000000000000000000000000000000000a0003000000000200000000000000010000014000100000000000000000240000000008000000000;
        VGA_protect[44]<=480'h000000000000000000000000000700000000000040000000000000000000000000000000000008000000000000000000000000000000000000000000;
        VGA_protect[45]<=480'h000000000000000000000000000000000000000000000000000000000000000000000000000004000140000000000000000000000000000000000000;
        VGA_protect[46]<=480'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;        
        VGA_protect[47]<=480'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;                                

        end
        end
        always@(negedge rst or posedge pclk1)
        begin
        if(rst==0)begin
        if(vcount1>=VGA_protect_up&&vcount1<=VGA_protect_up+48&&hcount1>=VGA_protect_left&&hcount1<=VGA_protect_left+480)
        begin
        if(VGA_protect[vcount1-VGA_protect_up][479-(hcount1-VGA_protect_left)]==1)
        begin
        r2 <= 3'b111;    
        g2 <= 3'b000;    
        b2 <= 2'b00; 
        end
        else if(VGA_protect[vcount1-VGA_protect_up][479-(hcount1-VGA_protect_left)]==0)
        begin
        r2 <= 3'b111;    
        g2 <= 3'b111;    
        b2 <= 2'b00; 
        end
        end   
        else begin                 
        r2 <= 3'b000;    
        g2 <= 3'b000;    
        b2 <= 2'b00; 
        end
        end
        end
        
        
        
        always@(posedge vs1 or negedge rst)
        begin
        if(rst==1)
        begin
        VGA_protect_up<=200;
        VGA_protect_left<=5;
        end
        else if(VGA_protect_left<=763)
        begin
        VGA_protect_left<=VGA_protect_left+1;
        end
        else begin VGA_protect_left<=5;
        end
        end

        
        always @ (posedge pclk or posedge rst)    
        begin    
                if (rst==0) 
                begin
                end    
                else begin
                if(((vcount>=up_pos[0] && vcount<=down_pos[0]    
                && hcount>=left_pos[0] && hcount<=right_pos[0]&&btn==2'b00)
                ||(vcount>=up_pos[0] && vcount<=down_pos[0]    
                && hcount>=(left_pos[0]-30) && hcount<=(right_pos[0]-30)&&btn==2'b00))&&count_light==2'b01)
                begin    
                r <= 3'b111;    
                g <= 3'b000;    
                b <= 2'b00;    
                end
                else if(((vcount>=up_pos[0] && vcount<=down_pos[0]    
                && hcount>=left_pos[0] && hcount<=right_pos[0]&&btn==2'b01)
                ||(vcount>=up_pos[0] && vcount<=down_pos[0]    
                && hcount>=(left_pos[0]-30) && hcount<=(right_pos[0]-30)&&btn==2'b01))&&count_light==2'b01)                  
                begin    
                r <= 3'b111;    
                g <= 3'b111;    
                b <= 2'b00;    
                end 
                else if(((vcount>=up_pos[0] && vcount<=down_pos[0]&& hcount>=left_pos[0] && hcount<=right_pos[0]&&btn==2'b11)
                ||(vcount>=up_pos[0] && vcount<=down_pos[0]    
                && hcount>=(left_pos[0]-30) && hcount<=(right_pos[0]-30)&&btn==2'b11))&&count_light==2'b01) 
                begin    
                r <= 3'b000;    
                g <= 3'b111;    
                b <= 2'b00;    
                end
                else if(((vcount>=up_pos[0] && vcount<=down_pos[0]    
                && hcount>=left_pos[0] && hcount<=right_pos[0])
                ||(vcount>=up_pos[0] && vcount<=down_pos[0]    
                && hcount>=(left_pos[0]-30) && hcount<=(right_pos[0]-30)))&&count_light!=2'b01)
                begin    
                r <= 3'b111;    
                g <= 3'b000;    
                b <= 2'b00;    
                end
                else if(vcount>=up_pos[0] && vcount<=down_pos[0]&& hcount>=(left_pos[0]+30) && hcount<=(right_pos[0]+30)) 
                begin    
                r <= 3'b000;    
                g <= 3'b111;    
                b <= 2'b00;    
                end                                                                            
                else if(((vcount>=up_pos[1] && vcount<=down_pos[1]&&hcount>=left_pos[1]&&hcount<=right_pos[1]&&btn2==2'b00)
                ||(vcount>=(up_pos[1]+30) && vcount<=(down_pos[1]+30)&&hcount>=left_pos[1]&&hcount<=right_pos[1]&&btn2==2'b00))&&count_light==2'b10)
                begin    
                r <= 3'b111;    
                g <= 3'b000;    
                b <= 2'b00;    
                end   
                else if(((vcount>=up_pos[1]&&vcount<=down_pos[1]&&hcount>=left_pos[1]&&hcount<=right_pos[1]&&btn2==2'b01)
                ||(vcount>=(up_pos[1]+30) && vcount<=(down_pos[1]+30)&&hcount>=left_pos[1]&&hcount<=right_pos[1]&&btn2==2'b01))&&count_light==2'b10)                
                begin    
                r <= 3'b111;    
                g <= 3'b111;    
                b <= 2'b00;    
                end
                else if(((vcount>=up_pos[1]&&vcount<=down_pos[1]&&hcount>=left_pos[1]&&hcount<=right_pos[1]&&btn2==2'b11)
                ||(vcount>=(up_pos[1]+30) && vcount<=(down_pos[1]+30)&&hcount>=left_pos[1]&&hcount<=right_pos[1]&&btn2==2'b11))&&count_light==2'b10)
                begin    
                r <= 3'b000;    
                g <= 3'b111;    
                b <= 2'b00;      
                end
                else if(((vcount>=up_pos[1]&&vcount<=down_pos[1]&&hcount>=left_pos[1]&&hcount<=right_pos[1])
                ||(vcount>=(up_pos[1]+30) && vcount<=(down_pos[1]+30)&&hcount>=left_pos[1]&&hcount<=right_pos[1]))&&count_light!=2'b10)
                begin    
                r <= 3'b111;    
                g <= 3'b000;    
                b <= 2'b00;      
                end 
                else if(vcount>=(up_pos[1]-30) && vcount<=(down_pos[1]-30)&& hcount>=(left_pos[1]) && hcount<=(right_pos[1])) 
                begin    
                r <= 3'b000;    
                g <= 3'b111;    
                b <= 2'b00;    
                end
                else if(((vcount>=up_pos[2] && vcount<=down_pos[2]    
                && hcount>=left_pos[2] && hcount<=right_pos[2])
                ||(vcount>=up_pos[2] && vcount<=down_pos[2]    
                && hcount>=(left_pos[2]+30) && hcount<=(right_pos[2]+30)))&&count_light==2'b11)
                begin 
                if(btn==2'b01||btn2==2'b01)
                begin   
                r <= 3'b111;    
                g <= 3'b111;    
                b <= 2'b00;    
                end
                else begin
                r <= 3'b000;    
                g <= 3'b111;    
                b <= 2'b00;
                end
                end
                else if(((vcount>=up_pos[2] && vcount<=down_pos[2]    
                && hcount>=left_pos[2] && hcount<=right_pos[2])
                ||(vcount>=up_pos[2] && vcount<=down_pos[2]    
                && hcount>=(left_pos[2]+30) && hcount<=(right_pos[2]+30)))&&count_light!=2'b11)
                begin    
                r <= 3'b111;    
                g <= 3'b000;    
                b <= 2'b00;    
                end
                else if(vcount>=up_pos[2] && vcount<=down_pos[2]&& hcount>=(left_pos[2]-30) && hcount<=(right_pos[2]-30)) 
                begin    
                r <= 3'b000;    
                g <= 3'b111;    
                b <= 2'b00;    
                end 
                else if(((vcount>=up_pos[3] && vcount<=down_pos[3]&&hcount>=left_pos[3]&&hcount<=right_pos[3]&&btn2==2'b00)
                ||(vcount>=(up_pos[3]-30) && vcount<=(down_pos[3]-30)&&hcount>=left_pos[3]&&hcount<=right_pos[3]&&btn2==2'b00))&&count_light!=2'b11&&count_light!=2'b10&&count_light!=2'b01)
                begin    
                r <= 3'b111;    
                g <= 3'b000;    
                b <= 2'b00;    
                end   
                else if(((vcount>=up_pos[3]&&vcount<=down_pos[3]&&hcount>=left_pos[3]&&hcount<=right_pos[3]&&btn2==2'b01)
                ||(vcount>=(up_pos[3]-30) && vcount<=(down_pos[3]-30)&&hcount>=left_pos[3]&&hcount<=right_pos[3]&&btn2==2'b01))&&count_light!=2'b11&&count_light!=2'b10&&count_light!=2'b01)                
                begin    
                r <= 3'b111;    
                g <= 3'b111;    
                b <= 2'b00;    
                end
                else if(((vcount>=up_pos[3]&&vcount<=down_pos[3]&&hcount>=left_pos[3]&&hcount<=right_pos[3]&&btn2==2'b11)
                ||(vcount>=(up_pos[3]-30) && vcount<=(down_pos[3]-30)&&hcount>=left_pos[3]&&hcount<=right_pos[3]&&btn2==2'b11))&&count_light!=2'b11&&count_light!=2'b10&&count_light!=2'b01)
                begin    
                r <= 3'b000;    
                g <= 3'b111;    
                b <= 2'b00;      
                end                                               
                else if(((vcount>=up_pos[3]&&vcount<=down_pos[3]&&hcount>=left_pos[3]&&hcount<=right_pos[3])
                ||(vcount>=(up_pos[3]-30) && vcount<=(down_pos[3]-30)&&hcount>=left_pos[3]&&hcount<=right_pos[3]))&&count_light!=2'b00)
                begin    
                r <= 3'b111;    
                g <= 3'b000;    
                b <= 2'b00;      
                end 
                else if(vcount>=(up_pos[3]+30) && vcount<=(down_pos[3]+30)&& hcount>=(left_pos[3]) && hcount<=(right_pos[3])) 
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
                else if((vcount>=car_straight_up[0]&&vcount<=car_straight_up[0]+28&&hcount>=car_straight_left[0]&&hcount<=car_straight_left[0]+28
                &&car[vcount-car_straight_up[0]][28-(hcount-car_straight_left[0])]==1)
                ||((vcount>=car_straight_up[0]&&vcount<=car_straight_up[0]+28&&hcount>=car_straight_left[0]+35&&hcount<=car_straight_left[0]+28+35
                &&car[vcount-car_straight_up[0]][28-(hcount-car_straight_left[0]-35)]==1))||
                (vcount>=car_straight_up[0]&&vcount<=car_straight_up[0]+28&&hcount>=car_straight_left[0]+85&&hcount<=car_straight_left[0]+28+85
                &&car[vcount-car_straight_up[0]][28-(hcount-car_straight_left[0]-85)]==1)
                ||((vcount>=car_straight_up[0]&&vcount<=car_straight_up[0]+28&&hcount>=car_straight_left[0]+120&&hcount<=car_straight_left[0]+28+120
                &&car[vcount-car_straight_up[0]][28-(hcount-car_straight_left[0]-120)]==1)))
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;   
                end

                else if((vcount>=car_straight_up[1]&&vcount<=car_straight_up[1]+28&&hcount>=car_straight_left[1]&&hcount<=car_straight_left[1]+28
                &&car[28-(hcount-car_straight_left[1])][vcount-car_straight_up[1]]==1)||
                (vcount>=car_straight_up[1]-36&&vcount<=car_straight_up[1]+28-36&&hcount>=car_straight_left[1]&&hcount<=car_straight_left[1]+28
                &&car[28-(hcount-car_straight_left[1])][vcount-car_straight_up[1]+36]==1))
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00;   
                end

                else if((vcount>=car_straight_up[2]&&vcount<=car_straight_up[2]+28&&hcount>=car_straight_left[2]&&hcount<=car_straight_left[2]+28
                &&car[vcount-car_straight_up[2]][28-(hcount-car_straight_left[2])]==1)||
                (vcount>=car_straight_up[2]&&vcount<=car_straight_up[2]+28&&hcount>=car_straight_left[2]-35&&hcount<=car_straight_left[2]+28-35
                &&car[vcount-car_straight_up[2]][28-(hcount-car_straight_left[2]+35)]==1)||
                (vcount>=car_straight_up[2]&&vcount<=car_straight_up[2]+28&&hcount>=car_straight_left[2]-85&&hcount<=car_straight_left[2]+28-85
                &&car[vcount-car_straight_up[2]][28-(hcount-car_straight_left[2]+85)]==1)||
                (vcount>=car_straight_up[2]&&vcount<=car_straight_up[2]+28&&hcount>=car_straight_left[2]-120&&hcount<=car_straight_left[2]+28-120
                &&car[vcount-car_straight_up[2]][28-(hcount-car_straight_left[2]+120)]==1))
                begin
                r<=3'b111;
                g<=3'b111;
                b<=2'b00;   
                end                
                else if((vcount>=car_straight_up[3]&&vcount<=car_straight_up[3]+28&&hcount>=car_straight_left[3]&&hcount<=car_straight_left[3]+28
                &&car[(hcount-car_straight_left[3])][vcount-car_straight_up[3]]==1)||
                (vcount>=car_straight_up[3]+38&&vcount<=car_straight_up[3]+28+38&&hcount>=car_straight_left[3]&&hcount<=car_straight_left[3]+28
                &&car[(hcount-car_straight_left[3])][vcount-car_straight_up[3]-38]==1))
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b11;   
                end
                //else if(vcount>=car_leftturn_up[0]&&vcount<=car_leftturn_up[0]+28)
                else if((hcount>=car_turn_right_left[0]&&hcount<=car_turn_right_right[0]&&
                vcount>=car_turn_right_up[0]&&vcount<=car_turn_right_down[0])||
                (hcount>=car_turn_right_left[0]&&hcount<=car_turn_right_right[0]&&
                vcount>=car_turn_right_up[0]+6&&vcount<=car_turn_right_down[0]+6)||
                (hcount>=car_turn_right_left[0]&&hcount<=car_turn_right_right[0]&&
                vcount>=car_turn_right_up[0]+12&&vcount<=car_turn_right_down[0]+12))
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;               
                end                                           
                else if((hcount>=car_turn_right_left[2]&&hcount<=car_turn_right_right[2]&&
                vcount>=car_turn_right_up[2]&&vcount<=car_turn_right_down[2])||
                (hcount>=car_turn_right_left[2]&&hcount<=car_turn_right_right[2]&&
                vcount>=car_turn_right_up[2]-6&&vcount<=car_turn_right_down[2]-6)||
                (hcount>=car_turn_right_left[2]&&hcount<=car_turn_right_right[2]&&
                vcount>=car_turn_right_up[2]-12&&vcount<=car_turn_right_down[2]-12)||
                (hcount>=car_turn_right_left[2]&&hcount<=car_turn_right_right[2]&&
                vcount>=car_turn_right_up[2]-18&&vcount<=car_turn_right_down[2]-18))
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;               
                end
                else if((hcount>=car_turn_right_left[3]&&hcount<=car_turn_right_right[3]&&
                vcount>=car_turn_right_up[3]&&vcount<=car_turn_right_down[3])||
                (hcount>=car_turn_right_left[3]-6&&hcount<=car_turn_right_right[3]-6&&
                vcount>=car_turn_right_up[3]&&vcount<=car_turn_right_down[3])||
                (hcount>=car_turn_right_left[3]-12&&hcount<=car_turn_right_right[3]-12&&
                vcount>=car_turn_right_up[3]&&vcount<=car_turn_right_down[3])||
                (hcount>=car_turn_right_left[3]-18&&hcount<=car_turn_right_right[3]-18&&
                vcount>=car_turn_right_up[3]&&vcount<=car_turn_right_down[3]))
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;               
                end 
                else if((hcount>=car_turn_left_left[3]&&hcount<=car_turn_left_right[3]&&
                vcount>=car_turn_left_up[3]&&vcount<=car_turn_left_down[3])||
                (hcount>=car_turn_left_left[3]-6&&hcount<=car_turn_left_right[3]-6&&
                vcount>=car_turn_left_up[3]&&vcount<=car_turn_left_down[3])||
                (hcount>=car_turn_left_left[3]-12&&hcount<=car_turn_left_right[3]-12&&
                vcount>=car_turn_left_up[3]&&vcount<=car_turn_left_down[3]))
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;                               
                end                                
                else if((hcount>=car_turn_left_left[0]&&hcount<=car_turn_left_right[0]&&
                vcount>=car_turn_left_up[0]&&vcount<=car_turn_left_down[0])||
                (hcount>=car_turn_left_left[0]&&hcount<=car_turn_left_right[0]&&
                vcount>=car_turn_left_up[0]+6&&vcount<=car_turn_left_down[0]+6)||
                (hcount>=car_turn_left_left[0]&&hcount<=car_turn_left_right[0]&&
                vcount>=car_turn_left_up[0]+12&&vcount<=car_turn_left_down[0]+12))
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;                               
                end
                else if((hcount>=car_turn_left_left[1]&&hcount<=car_turn_left_right[1]&&
                vcount>=car_turn_left_up[1]&&vcount<=car_turn_left_down[1])||
                (hcount>=car_turn_left_left[1]+6&&hcount<=car_turn_left_right[1]+6&&
                vcount>=car_turn_left_up[1]&&vcount<=car_turn_left_down[1])||
                (hcount>=car_turn_left_left[1]+12&&hcount<=car_turn_left_right[1]+12&&
                vcount>=car_turn_left_up[1]&&vcount<=car_turn_left_down[1]))
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;                               
                end
                else if((hcount>=car_turn_left_left[2]&&hcount<=car_turn_left_right[2]&&
                vcount>=car_turn_left_up[2]&&vcount<=car_turn_left_down[2])||
                (hcount>=car_turn_left_left[2]&&hcount<=car_turn_left_right[2]&&
                vcount>=car_turn_left_up[2]-6&&vcount<=car_turn_left_down[2]-6)||
                (hcount>=car_turn_left_left[2]&&hcount<=car_turn_left_right[2]&&
                vcount>=car_turn_left_up[2]-12&&vcount<=car_turn_left_down[2]-12))
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;                               
                end                                  
                else if((hcount>=down_car_position_left[0]&&hcount<=down_car_position_right[0]
                &&vcount>=down_car_position_up[0]&&vcount<=down_car_position_down[0])||
                (hcount>=down_car_position_left[0]&&hcount<=down_car_position_right[0]
                &&vcount>=(down_car_position_up[0]+12)&&vcount<=(down_car_position_down[0]+12))||
                (hcount>=down_car_position_left[0]&&hcount<=down_car_position_right[0]
                &&vcount>=(down_car_position_up[0]+6)&&vcount<=(down_car_position_down[0]+6))||
                (hcount>=down_car_position_left[0]&&hcount<=down_car_position_right[0]
               &&vcount>=(down_car_position_up[0]+18)&&vcount<=(down_car_position_down[0]+18))|| 
               (hcount>=down_car_position_left[0]+15&&hcount<=down_car_position_right[0]+15
               &&vcount>=down_car_position_up[0]&&vcount<=down_car_position_down[0])||
               (hcount>=down_car_position_left[0]+15&&hcount<=down_car_position_right[0]+15
               &&vcount>=(down_car_position_up[0]+12)&&vcount<=(down_car_position_down[0]+12))||
               (hcount>=down_car_position_left[0]+15&&hcount<=down_car_position_right[0]+15
               &&vcount>=(down_car_position_up[0]+6)&&vcount<=(down_car_position_down[0]+6))||
               (hcount>=down_car_position_left[0]+15&&hcount<=down_car_position_right[0]+15
               &&vcount>=(down_car_position_up[0]+18)&&vcount<=(down_car_position_down[0]+18))||           
               (hcount>=down_car_position_left[0]+30&&hcount<=down_car_position_right[0]+30
               &&vcount>=down_car_position_up[0]&&vcount<=down_car_position_down[0])||
               (hcount>=down_car_position_left[0]+30&&hcount<=down_car_position_right[0]+30
               &&vcount>=(down_car_position_up[0]+12)&&vcount<=(down_car_position_down[0]+12))||
               (hcount>=down_car_position_left[0]+30&&hcount<=down_car_position_right[0]+30
               &&vcount>=(down_car_position_up[0]+6)&&vcount<=(down_car_position_down[0]+6))||
               (hcount>=down_car_position_left[0]+30&&hcount<=down_car_position_right[0]+30
               &&vcount>=(down_car_position_up[0]+18)&&vcount<=(down_car_position_down[0]+18))||
               (hcount>=down_car_position_left[0]+45&&hcount<=down_car_position_right[0]+45
               &&vcount>=down_car_position_up[0]&&vcount<=down_car_position_down[0])||
               (hcount>=down_car_position_left[0]+45&&hcount<=down_car_position_right[0]+45
               &&vcount>=(down_car_position_up[0]+12)&&vcount<=(down_car_position_down[0]+12))||
               (hcount>=down_car_position_left[0]+45&&hcount<=down_car_position_right[0]+45
               &&vcount>=(down_car_position_up[0]+6)&&vcount<=(down_car_position_down[0]+6))||
               (hcount>=down_car_position_left[0]+45&&hcount<=down_car_position_right[0]+45
               &&vcount>=(down_car_position_up[0]+18)&&vcount<=(down_car_position_down[0]+18))||
                (hcount>=down_car_position_left[0]+60&&hcount<=down_car_position_right[0]+60
               &&vcount>=down_car_position_up[0]&&vcount<=down_car_position_down[0])||
               (hcount>=down_car_position_left[0]+60&&hcount<=down_car_position_right[0]+60
               &&vcount>=(down_car_position_up[0]+12)&&vcount<=(down_car_position_down[0]+12))||
               (hcount>=down_car_position_left[0]+60&&hcount<=down_car_position_right[0]+60
               &&vcount>=(down_car_position_up[0]+6)&&vcount<=(down_car_position_down[0]+6))||
               (hcount>=down_car_position_left[0]+60&&hcount<=down_car_position_right[0]+60
               &&vcount>=(down_car_position_up[0]+18)&&vcount<=(down_car_position_down[0]+18))||
               (hcount>=down_car_position_left[0]+75&&hcount<=down_car_position_right[0]+75
               &&vcount>=down_car_position_up[0]&&vcount<=down_car_position_down[0])||
               (hcount>=down_car_position_left[0]+75&&hcount<=down_car_position_right[0]+75
               &&vcount>=(down_car_position_up[0]+12)&&vcount<=(down_car_position_down[0]+12))||
               (hcount>=down_car_position_left[0]+75&&hcount<=down_car_position_right[0]+75
               &&vcount>=(down_car_position_up[0]+6)&&vcount<=(down_car_position_down[0]+6))||
               (hcount>=down_car_position_left[0]+75&&hcount<=down_car_position_right[0]+75
               &&vcount>=(down_car_position_up[0]+18)&&vcount<=(down_car_position_down[0]+18))               
               )
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;
                end
                else if((hcount>=down_car_position_left[0]+60+60&&hcount<=down_car_position_right[0]+60+60
                &&vcount>=down_car_position_up[0]&&vcount<=down_car_position_down[0])||
                (hcount>=down_car_position_left[0]+60+60&&hcount<=down_car_position_right[0]+60+60
                &&vcount>=(down_car_position_up[0]+12)&&vcount<=(down_car_position_down[0]+12))||
                (hcount>=down_car_position_left[0]+60+60&&hcount<=down_car_position_right[0]+60+60
                &&vcount>=(down_car_position_up[0]+6)&&vcount<=(down_car_position_down[0]+6))||
                (hcount>=down_car_position_left[0]+60+60&&hcount<=down_car_position_right[0]+60+60
               &&vcount>=(down_car_position_up[0]+18)&&vcount<=(down_car_position_down[0]+18))||
               (hcount>=down_car_position_left[0]+75+60&&hcount<=down_car_position_right[0]+75+60
               &&vcount>=down_car_position_up[0]&&vcount<=down_car_position_down[0])||
               (hcount>=down_car_position_left[0]+75+60&&hcount<=down_car_position_right[0]+75+60
               &&vcount>=(down_car_position_up[0]+12)&&vcount<=(down_car_position_down[0]+12))||
               (hcount>=down_car_position_left[0]+75+60&&hcount<=down_car_position_right[0]+75+60
               &&vcount>=(down_car_position_up[0]+6)&&vcount<=(down_car_position_down[0]+6))||
               (hcount>=down_car_position_left[0]+75+60&&hcount<=down_car_position_right[0]+75+60
               &&vcount>=(down_car_position_up[0]+18)&&vcount<=(down_car_position_down[0]+18))||                             
               (hcount>=down_car_position_left[0]+90+60&&hcount<=down_car_position_right[0]+90+60
               &&vcount>=down_car_position_up[0]&&vcount<=down_car_position_down[0])||
               (hcount>=down_car_position_left[0]+90+60&&hcount<=down_car_position_right[0]+90+60
               &&vcount>=(down_car_position_up[0]+12)&&vcount<=(down_car_position_down[0]+12))||
               (hcount>=down_car_position_left[0]+90+60&&hcount<=down_car_position_right[0]+90+60
               &&vcount>=(down_car_position_up[0]+6)&&vcount<=(down_car_position_down[0]+6))||
               (hcount>=down_car_position_left[0]+90+60&&hcount<=down_car_position_right[0]+90+60
               &&vcount>=(down_car_position_up[0]+18)&&vcount<=(down_car_position_down[0]+18)) ||  
               (hcount>=down_car_position_left[0]+90+75&&hcount<=down_car_position_right[0]+90+75
               &&vcount>=down_car_position_up[0]&&vcount<=down_car_position_down[0])||
               (hcount>=down_car_position_left[0]+90+75&&hcount<=down_car_position_right[0]+90+75
               &&vcount>=(down_car_position_up[0]+12)&&vcount<=(down_car_position_down[0]+12))||
               (hcount>=down_car_position_left[0]+90+75&&hcount<=down_car_position_right[0]+90+75
               &&vcount>=(down_car_position_up[0]+6)&&vcount<=(down_car_position_down[0]+6))||
               (hcount>=down_car_position_left[0]+90+75&&hcount<=down_car_position_right[0]+90+75
               &&vcount>=(down_car_position_up[0]+18)&&vcount<=(down_car_position_down[0]+18))
               ||(hcount>=down_car_position_left[0]+90+90&&hcount<=down_car_position_right[0]+90+90
               &&vcount>=down_car_position_up[0]&&vcount<=down_car_position_down[0])||
               (hcount>=down_car_position_left[0]+90+90&&hcount<=down_car_position_right[0]+90+90
               &&vcount>=(down_car_position_up[0]+12)&&vcount<=(down_car_position_down[0]+12))||
               (hcount>=down_car_position_left[0]+90+90&&hcount<=down_car_position_right[0]+90+90
               &&vcount>=(down_car_position_up[0]+6)&&vcount<=(down_car_position_down[0]+6))||
               (hcount>=down_car_position_left[0]+90+90&&hcount<=down_car_position_right[0]+90+90
               &&vcount>=(down_car_position_up[0]+18)&&vcount<=(down_car_position_down[0]+18))                             
               )
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;
                end                 
                else if((hcount>=up_car_position_left[0]&&hcount<=up_car_position_right[0]
                &&vcount>=up_car_position_up[0]&&vcount<=up_car_position_down[0])||
                (hcount>=up_car_position_left[0]&&hcount<=up_car_position_right[0]
                &&vcount>=(up_car_position_up[0]-12)&&vcount<=(up_car_position_down[0]-12))||
                (hcount>=up_car_position_left[0]&&hcount<=up_car_position_right[0]
                &&vcount>=(up_car_position_up[0]-6)&&vcount<=(up_car_position_down[0]-6))||
                (hcount>=up_car_position_left[0]&&hcount<=up_car_position_right[0]
               &&vcount>=(up_car_position_up[0]-18)&&vcount<=(up_car_position_down[0]-18))||       
               (hcount>=up_car_position_left[0]+15&&hcount<=up_car_position_right[0]+15
               &&vcount>=up_car_position_up[0]&&vcount<=up_car_position_down[0])||
               (hcount>=up_car_position_left[0]+15&&hcount<=up_car_position_right[0]+15
               &&vcount>=(up_car_position_up[0]-12)&&vcount<=(up_car_position_down[0]-12))||
               (hcount>=up_car_position_left[0]+15&&hcount<=up_car_position_right[0]+15
               &&vcount>=(up_car_position_up[0]-6)&&vcount<=(up_car_position_down[0]-6))||
               (hcount>=up_car_position_left[0]+15&&hcount<=up_car_position_right[0]+15
               &&vcount>=(up_car_position_up[0]-18)&&vcount<=(up_car_position_down[0]-18))||                                         
               (hcount>=up_car_position_left[0]+30&&hcount<=up_car_position_right[0]+30
               &&vcount>=up_car_position_up[0]&&vcount<=up_car_position_down[0])||
               (hcount>=up_car_position_left[0]+30&&hcount<=up_car_position_right[0]+30
               &&vcount>=(up_car_position_up[0]-12)&&vcount<=(up_car_position_down[0]-12))||
               (hcount>=up_car_position_left[0]+30&&hcount<=up_car_position_right[0]+30
               &&vcount>=(up_car_position_up[0]-6)&&vcount<=(up_car_position_down[0]-6))||
               (hcount>=up_car_position_left[0]+30&&hcount<=up_car_position_right[0]+30
               &&vcount>=(up_car_position_up[0]-18)&&vcount<=(up_car_position_down[0]-18))||
               (hcount>=up_car_position_left[0]-15&&hcount<=up_car_position_right[0]-15
               &&vcount>=up_car_position_up[0]&&vcount<=up_car_position_down[0])||
               (hcount>=up_car_position_left[0]-15&&hcount<=up_car_position_right[0]-15
               &&vcount>=(up_car_position_up[0]-12)&&vcount<=(up_car_position_down[0]-12))||
               (hcount>=up_car_position_left[0]-15&&hcount<=up_car_position_right[0]-15
               &&vcount>=(up_car_position_up[0]-6)&&vcount<=(up_car_position_down[0]-6))||
               (hcount>=up_car_position_left[0]-15&&hcount<=up_car_position_right[0]-15
               &&vcount>=(up_car_position_up[0]-18)&&vcount<=(up_car_position_down[0]-18))||
               (hcount>=up_car_position_left[0]-30&&hcount<=up_car_position_right[0]-30
               &&vcount>=up_car_position_up[0]&&vcount<=up_car_position_down[0])||
               (hcount>=up_car_position_left[0]-30&&hcount<=up_car_position_right[0]-30
               &&vcount>=(up_car_position_up[0]-12)&&vcount<=(up_car_position_down[0]-12))||
               (hcount>=up_car_position_left[0]-30&&hcount<=up_car_position_right[0]-30
               &&vcount>=(up_car_position_up[0]-6)&&vcount<=(up_car_position_down[0]-6))||
               (hcount>=up_car_position_left[0]-30&&hcount<=up_car_position_right[0]-30
               &&vcount>=(up_car_position_up[0]-18)&&vcount<=(up_car_position_down[0]-18))||
               (hcount>=up_car_position_left[0]-45&&hcount<=up_car_position_right[0]-45
               &&vcount>=up_car_position_up[0]&&vcount<=up_car_position_down[0])||
               (hcount>=up_car_position_left[0]-45&&hcount<=up_car_position_right[0]-45
               &&vcount>=(up_car_position_up[0]-12)&&vcount<=(up_car_position_down[0]-12))||
               (hcount>=up_car_position_left[0]-45&&hcount<=up_car_position_right[0]-45
               &&vcount>=(up_car_position_up[0]-6)&&vcount<=(up_car_position_down[0]-6))||
               (hcount>=up_car_position_left[0]-45&&hcount<=up_car_position_right[0]-45
               &&vcount>=(up_car_position_up[0]-18)&&vcount<=(up_car_position_down[0]-18))                              
               )
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;
                end
                else if((hcount>=up_car_position_left[0]-60-40&&hcount<=up_car_position_right[0]-60-40
                &&vcount>=up_car_position_up[0]&&vcount<=up_car_position_down[0])||
                (hcount>=up_car_position_left[0]-60-40&&hcount<=up_car_position_right[0]-60-40
                &&vcount>=(up_car_position_up[0]-12)&&vcount<=(up_car_position_down[0]-12))||
                (hcount>=up_car_position_left[0]-60-40&&hcount<=up_car_position_right[0]-60-40
                &&vcount>=(up_car_position_up[0]-6)&&vcount<=(up_car_position_down[0]-6))||
                (hcount>=up_car_position_left[0]-60-40&&hcount<=up_car_position_right[0]-60-40
               &&vcount>=(up_car_position_up[0]-18)&&vcount<=(up_car_position_down[0]-18))||
               (hcount>=up_car_position_left[0]-75-40&&hcount<=up_car_position_right[0]-75-40
               &&vcount>=up_car_position_up[0]&&vcount<=up_car_position_down[0])||
               (hcount>=up_car_position_left[0]-75-40&&hcount<=up_car_position_right[0]-75-40
               &&vcount>=(up_car_position_up[0]-12)&&vcount<=(up_car_position_down[0]-12))||
               (hcount>=up_car_position_left[0]-75-40&&hcount<=up_car_position_right[0]-75-40
               &&vcount>=(up_car_position_up[0]-6)&&vcount<=(up_car_position_down[0]-6))||
               (hcount>=up_car_position_left[0]-75-40&&hcount<=up_car_position_right[0]-75-40
               &&vcount>=(up_car_position_up[0]-18)&&vcount<=(up_car_position_down[0]-18))||                             
               (hcount>=up_car_position_left[0]-90-40&&hcount<=up_car_position_right[0]-90-40
               &&vcount>=up_car_position_up[0]&&vcount<=up_car_position_down[0])||
               (hcount>=up_car_position_left[0]-90-40&&hcount<=up_car_position_right[0]-90-40
               &&vcount>=(up_car_position_up[0]-12)&&vcount<=(up_car_position_down[0]-12))||
               (hcount>=up_car_position_left[0]-90-40&&hcount<=up_car_position_right[0]-90-40
               &&vcount>=(up_car_position_up[0]-6)&&vcount<=(up_car_position_down[0]-6))||
               (hcount>=up_car_position_left[0]-90-40&&hcount<=up_car_position_right[0]-90-40
               &&vcount>=(up_car_position_up[0]-18)&&vcount<=(up_car_position_down[0]-18)) ||
               (hcount>=up_car_position_left[0]-90-40+15&&hcount<=up_car_position_right[0]-90-40+15
               &&vcount>=up_car_position_up[0]&&vcount<=up_car_position_down[0])||
               (hcount>=up_car_position_left[0]-90-40+15&&hcount<=up_car_position_right[0]-90-40+15
               &&vcount>=(up_car_position_up[0]-12)&&vcount<=(up_car_position_down[0]-12))||
               (hcount>=up_car_position_left[0]-90-40+15&&hcount<=up_car_position_right[0]-90-40+15
               &&vcount>=(up_car_position_up[0]-6)&&vcount<=(up_car_position_down[0]-6))||
               (hcount>=up_car_position_left[0]-90-40+15&&hcount<=up_car_position_right[0]-90-40+15
               &&vcount>=(up_car_position_up[0]-18)&&vcount<=(up_car_position_down[0]-18))  
               ||(hcount>=up_car_position_left[0]-90-40+30&&hcount<=up_car_position_right[0]-90-40+30
               &&vcount>=up_car_position_up[0]&&vcount<=up_car_position_down[0])||
               (hcount>=up_car_position_left[0]-90-40+30&&hcount<=up_car_position_right[0]-90-40+30
               &&vcount>=(up_car_position_up[0]-12)&&vcount<=(up_car_position_down[0]-12))||
               (hcount>=up_car_position_left[0]-90-40+30&&hcount<=up_car_position_right[0]-90-40+30
               &&vcount>=(up_car_position_up[0]-6)&&vcount<=(up_car_position_down[0]-6))||
               (hcount>=up_car_position_left[0]-90-40+30&&hcount<=up_car_position_right[0]-90-40+30
               &&vcount>=(up_car_position_up[0]-18)&&vcount<=(up_car_position_down[0]-18))||
               (hcount>=up_car_position_left[0]-90-40+45&&hcount<=up_car_position_right[0]-90-40+45
               &&vcount>=up_car_position_up[0]&&vcount<=up_car_position_down[0])||
               (hcount>=up_car_position_left[0]-90-40+45&&hcount<=up_car_position_right[0]-90-40+45
               &&vcount>=(up_car_position_up[0]-12)&&vcount<=(up_car_position_down[0]-12))||
               (hcount>=up_car_position_left[0]-90-40+45&&hcount<=up_car_position_right[0]-90-40+45
               &&vcount>=(up_car_position_up[0]-6)&&vcount<=(up_car_position_down[0]-6))||
               (hcount>=up_car_position_left[0]-90-40+45&&hcount<=up_car_position_right[0]-90-40+45
               &&vcount>=(up_car_position_up[0]-18)&&vcount<=(up_car_position_down[0]-18))                             
               )
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;
                end
                else if((hcount>=right_car_position_left[0]&&hcount<=right_car_position_right[0]
                &&vcount>=right_car_position_up[0]&&vcount<=right_car_position_down[0])||
                (hcount>=right_car_position_left[0]+6&&hcount<=right_car_position_right[0]+6
                &&vcount>=(right_car_position_up[0])&&vcount<=(right_car_position_down[0]))||
                (hcount>=right_car_position_left[0]+12&&hcount<=right_car_position_right[0]+12
                &&vcount>=(right_car_position_up[0])&&vcount<=(right_car_position_down[0]))||
                (hcount>=right_car_position_left[0]+18&&hcount<=right_car_position_right[0]+18
               &&vcount>=(right_car_position_up[0])&&vcount<=(right_car_position_down[0]))||          
               (hcount>=right_car_position_left[0]&&hcount<=right_car_position_right[0]
               &&vcount>=right_car_position_up[0]+10&&vcount<=right_car_position_down[0]+10)||
               (hcount>=right_car_position_left[0]+6&&hcount<=right_car_position_right[0]+6
               &&vcount>=(right_car_position_up[0]+10)&&vcount<=(right_car_position_down[0]+10))||
               (hcount>=right_car_position_left[0]+12&&hcount<=right_car_position_right[0]+12
               &&vcount>=(right_car_position_up[0]+10)&&vcount<=(right_car_position_down[0]+10))||
               (hcount>=right_car_position_left[0]+18&&hcount<=right_car_position_right[0]+18
               &&vcount>=(right_car_position_up[0]+10)&&vcount<=(right_car_position_down[0]+10))||                                          
               (hcount>=right_car_position_left[0]&&hcount<=right_car_position_right[0]
               &&vcount>=right_car_position_up[0]+20&&vcount<=right_car_position_down[0]+20)||
               (hcount>=right_car_position_left[0]+6&&hcount<=right_car_position_right[0]+6
               &&vcount>=(right_car_position_up[0]+20)&&vcount<=(right_car_position_down[0]+20))||
               (hcount>=right_car_position_left[0]+12&&hcount<=right_car_position_right[0]+12
               &&vcount>=(right_car_position_up[0]+20)&&vcount<=(right_car_position_down[0]+20))||
               (hcount>=right_car_position_left[0]+18&&hcount<=right_car_position_right[0]+18
               &&vcount>=(right_car_position_up[0]+20)&&vcount<=(right_car_position_down[0]+20))                              
               )
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;
                end
                else if((hcount>=right_car_position_left[0]&&hcount<=right_car_position_right[0]
                &&vcount>=right_car_position_up[0]-40&&vcount<=right_car_position_down[0]-40)||
                (hcount>=right_car_position_left[0]+6&&hcount<=right_car_position_right[0]+6
                &&vcount>=(right_car_position_up[0]-40)&&vcount<=(right_car_position_down[0]-40))||
                (hcount>=right_car_position_left[0]+12&&hcount<=right_car_position_right[0]+12
                &&vcount>=(right_car_position_up[0]-40)&&vcount<=(right_car_position_down[0]-40))||
                (hcount>=right_car_position_left[0]+18&&hcount<=right_car_position_right[0]+18
               &&vcount>=(right_car_position_up[0]-40)&&vcount<=(right_car_position_down[0]-40))||           
               (hcount>=right_car_position_left[0]&&hcount<=right_car_position_right[0]
               &&vcount>=right_car_position_up[0]-20&&vcount<=right_car_position_down[0]-20)||
               (hcount>=right_car_position_left[0]+6&&hcount<=right_car_position_right[0]+6
               &&vcount>=(right_car_position_up[0]-20)&&vcount<=(right_car_position_down[0]-20))||
               (hcount>=right_car_position_left[0]+12&&hcount<=right_car_position_right[0]+12
               &&vcount>=(right_car_position_up[0]-20)&&vcount<=(right_car_position_down[0]-20))||
               (hcount>=right_car_position_left[0]+18&&hcount<=right_car_position_right[0]+18
               &&vcount>=(right_car_position_up[0]-20)&&vcount<=(right_car_position_down[0]-20))||
               (hcount>=right_car_position_left[0]&&hcount<=right_car_position_right[0]
               &&vcount>=right_car_position_up[0]-30&&vcount<=right_car_position_down[0]-30)||
               (hcount>=right_car_position_left[0]+6&&hcount<=right_car_position_right[0]+6
               &&vcount>=(right_car_position_up[0]-30)&&vcount<=(right_car_position_down[0]-30))||
               (hcount>=right_car_position_left[0]+12&&hcount<=right_car_position_right[0]+12
               &&vcount>=(right_car_position_up[0]-30)&&vcount<=(right_car_position_down[0]-30))||
               (hcount>=right_car_position_left[0]+18&&hcount<=right_car_position_right[0]+18
               &&vcount>=(right_car_position_up[0]-30)&&vcount<=(right_car_position_down[0]-30))                              
               )
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;
                end 
                else if((hcount>=left_car_position_left[0]&&hcount<=left_car_position_right[0]
                &&vcount>=left_car_position_up[0]&&vcount<=left_car_position_down[0])||
                (hcount>=left_car_position_left[0]-6&&hcount<=left_car_position_right[0]-6
                &&vcount>=(left_car_position_up[0])&&vcount<=(left_car_position_down[0]))||
                (hcount>=left_car_position_left[0]-12&&hcount<=left_car_position_right[0]-12
                &&vcount>=(left_car_position_up[0])&&vcount<=(left_car_position_down[0]))||
                (hcount>=left_car_position_left[0]-18&&hcount<=left_car_position_right[0]-18
               &&vcount>=(left_car_position_up[0])&&vcount<=(left_car_position_down[0]))||                     
               (hcount>=left_car_position_left[0]&&hcount<=left_car_position_right[0]
               &&vcount>=left_car_position_up[0]-10&&vcount<=left_car_position_down[0]-10)||
               (hcount>=left_car_position_left[0]-6&&hcount<=left_car_position_right[0]-6
               &&vcount>=(left_car_position_up[0]-10)&&vcount<=(left_car_position_down[0]-10))||
               (hcount>=left_car_position_left[0]-12&&hcount<=left_car_position_right[0]-12
               &&vcount>=(left_car_position_up[0]-10)&&vcount<=(left_car_position_down[0]-10))||
               (hcount>=left_car_position_left[0]-18&&hcount<=left_car_position_right[0]-18
               &&vcount>=(left_car_position_up[0]-10)&&vcount<=(left_car_position_down[0]-10))||    
               (hcount>=left_car_position_left[0]&&hcount<=left_car_position_right[0]
               &&vcount>=left_car_position_up[0]-20&&vcount<=left_car_position_down[0]-20)||
               (hcount>=left_car_position_left[0]-6&&hcount<=left_car_position_right[0]-6
               &&vcount>=(left_car_position_up[0]-20)&&vcount<=(left_car_position_down[0]-20))||
               (hcount>=left_car_position_left[0]-12&&hcount<=left_car_position_right[0]-12
               &&vcount>=(left_car_position_up[0]-20)&&vcount<=(left_car_position_down[0]-20))||
               (hcount>=left_car_position_left[0]-18&&hcount<=left_car_position_right[0]-18
               &&vcount>=(left_car_position_up[0]-20)&&vcount<=(left_car_position_down[0]-20))                              
               )
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;
                end
                else if((hcount>=left_car_position_left[0]&&hcount<=left_car_position_right[0]
                &&vcount>=left_car_position_up[0]+20&&vcount<=left_car_position_down[0]+20)||
                (hcount>=left_car_position_left[0]-6&&hcount<=left_car_position_right[0]-6
                &&vcount>=(left_car_position_up[0]+20)&&vcount<=(left_car_position_down[0]+20))||
                (hcount>=left_car_position_left[0]-12&&hcount<=left_car_position_right[0]-12
                &&vcount>=(left_car_position_up[0]+20)&&vcount<=(left_car_position_down[0]+20))||
                (hcount>=left_car_position_left[0]-18&&hcount<=left_car_position_right[0]-18
               &&vcount>=(left_car_position_up[0]+20)&&vcount<=(left_car_position_down[0]+20))||                           
               (hcount>=left_car_position_left[0]&&hcount<=left_car_position_right[0]
               &&vcount>=left_car_position_up[0]+30&&vcount<=left_car_position_down[0]+30)||
               (hcount>=left_car_position_left[0]-6&&hcount<=left_car_position_right[0]-6
               &&vcount>=(left_car_position_up[0]+30)&&vcount<=(left_car_position_down[0]+30))||
               (hcount>=left_car_position_left[0]-12&&hcount<=left_car_position_right[0]-12
               &&vcount>=(left_car_position_up[0]+30)&&vcount<=(left_car_position_down[0]+30))||
               (hcount>=left_car_position_left[0]-18&&hcount<=left_car_position_right[0]-18
               &&vcount>=(left_car_position_up[0]+30)&&vcount<=(left_car_position_down[0]+30))|| 
               (hcount>=left_car_position_left[0]&&hcount<=left_car_position_right[0]
               &&vcount>=left_car_position_up[0]+40&&vcount<=left_car_position_down[0]+40)||
               (hcount>=left_car_position_left[0]-6&&hcount<=left_car_position_right[0]-6
               &&vcount>=(left_car_position_up[0]+40)&&vcount<=(left_car_position_down[0]+40))||
               (hcount>=left_car_position_left[0]-12&&hcount<=left_car_position_right[0]-12
               &&vcount>=(left_car_position_up[0]+40)&&vcount<=(left_car_position_down[0]+40))||
               (hcount>=left_car_position_left[0]-18&&hcount<=left_car_position_right[0]-18
               &&vcount>=(left_car_position_up[0]+40)&&vcount<=(left_car_position_down[0]+40))                              
               )
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;
                end                            
                else if((hcount>=car_turn_right_left[1]+6&&hcount<=car_turn_right_right[1]+6&&
                vcount>=car_turn_right_up[1]&&vcount<=car_turn_right_down[1])||
                (hcount>=car_turn_right_left[1]+12&&hcount<=car_turn_right_right[2]+12&&
                vcount>=car_turn_right_up[1]&&vcount<=car_turn_right_down[1])||
                (hcount>=car_turn_right_left[1]+18&&hcount<=car_turn_right_right[1]+18&&
                vcount>=car_turn_right_up[1]&&vcount<=car_turn_right_down[1])||
                (hcount>=car_turn_right_left[1]&&hcount<=car_turn_right_right[1]&&
                vcount>=car_turn_right_up[1]&&vcount<=car_turn_right_down[1]))
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;               
                end  
                else if(hcount>=shuzi_left&&hcount<shuzi_right&&vcount>=shuzi_up&&vcount<shuzi_down&&
                count_left[(vcount-shuzi_up)][19-(hcount-shuzi_left)]==1&&count_light==2'b01)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00; 
                end
                else if(hcount>=shuzi_left-30&&hcount<shuzi_right-30&&vcount>=shuzi_up&&vcount<shuzi_down&&
                count_right[(vcount-shuzi_up)][19-(hcount-shuzi_left+30)]==1&&count_light==2'b01)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00; 
                end                         
                else if(hcount>=shuzi_left&&hcount<shuzi_right&&vcount>=shuzi_up-30&&vcount<shuzi_down-30&&
                count_left[hcount-shuzi_left][vcount-shuzi_up+30]==1&&count_light==2'b10)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00; 
                end
                else if(hcount>=shuzi_left&&hcount<shuzi_right&&vcount>=shuzi_up&&vcount<shuzi_down&&
                count_right[hcount-shuzi_left][vcount-shuzi_up]==1&&count_light==2'b10)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00; 
                end 
                else if(hcount>=shuzi_left&&hcount<shuzi_right&&vcount>=shuzi_up&&vcount<shuzi_down&&
                count_left[(vcount-shuzi_up)][19-(hcount-shuzi_left)]==1&&count_light==2'b11)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00; 
                end
                else if(hcount>=shuzi_left-30&&hcount<shuzi_right-30&&vcount>=shuzi_up&&vcount<shuzi_down&&
                count_right[(vcount-shuzi_up)][19-(hcount-shuzi_left+30)]==1&&count_light==2'b11)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00; 
                end                                     
                else if(hcount>=shuzi_left&&hcount<shuzi_right&&vcount>=shuzi_up&&vcount<shuzi_down&&
                count_left[hcount-shuzi_left][vcount-shuzi_up]==1&&count_light==2'b00)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00; 
                end
                else if(hcount>=shuzi_left&&hcount<shuzi_right&&vcount>=shuzi_up+30&&vcount<shuzi_down+30&&
                count_right[hcount-shuzi_left][vcount-shuzi_up-30]==1&&count_light==2'b00)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00; 
                end   
                else if((hcount>=jiantou_left_position[0]&&hcount<=jiantou_right_position[0]
                &&vcount>=jiantou_up_position[0]&&vcount<=jiantou_down_position[0]
                &&jiantou_down_down[vcount-jiantou_up_position[0]][10-(hcount-jiantou_left_position[0])]==1))
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00; 
                end
                else if((hcount>=(jiantou_left_position[0]+120)&&hcount<=(jiantou_right_position[0]+120)
                &&vcount>=jiantou_up_position[0]&&vcount<=jiantou_down_position[0]
                &&jiantou_down_down[vcount-jiantou_up_position[0]][10-(hcount-jiantou_left_position[0]-120)]==1))
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00; 
                end                      
                else if(hcount>=jiantou_left_position[1]&&hcount<=jiantou_right_position[1]
                &&vcount>=jiantou_up_position[1]&&vcount<=jiantou_down_position[1]
                &&jiantou_double_down[vcount-jiantou_up_position[1]][19-(hcount-jiantou_left_position[1])]==1)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00; 
                end                 
                else if(hcount>=(jiantou_left_position[1]+120)&&hcount<=(jiantou_right_position[1]+120)
                &&vcount>=jiantou_up_position[1]&&vcount<=jiantou_down_position[1]
                &&jiantou_double_down1[vcount-jiantou_up_position[1]][19-(hcount-jiantou_left_position[1]-120)]==1)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00; 
                end        
                else if(hcount>=jiantou_left_position[2]&&hcount<=jiantou_right_position[2]
                &&vcount>=jiantou_up_position[2]&&vcount<=jiantou_down_position[2]
                &&jiantou_down_right[vcount-jiantou_up_position[2]][10-(hcount-jiantou_left_position[2])]==1)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00; 
                end                 
                else if(hcount>=(jiantou_left_position[2])&&hcount<=(jiantou_right_position[2])
                &&vcount>=(jiantou_up_position[2]-60)&&vcount<=(jiantou_down_position[2]-60)
                &&jiantou_down_right[vcount-jiantou_up_position[2]+60][10-(hcount-jiantou_left_position[2])]==1)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00; 
                end       
                else if(hcount>=jiantou_left_position[3]&&hcount<=jiantou_right_position[3]
                &&vcount>=jiantou_up_position[3]&&vcount<=jiantou_down_position[3]
                &&jiantou_double_right[vcount-jiantou_up_position[3]][19-(hcount-jiantou_left_position[3])]==1)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00; 
                end                 
                else if(hcount>=(jiantou_left_position[3])&&hcount<=(jiantou_right_position[3])
                &&vcount>=(jiantou_up_position[3]-60)&&vcount<=(jiantou_down_position[3]-60)
                &&jiantou_double_right[19-(vcount-jiantou_up_position[3]+60)][19-(hcount-jiantou_left_position[3])]==1)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00; 
                end                 
                else if(hcount>=jiantou_left_position[4]&&hcount<=jiantou_right_position[4]
                &&vcount>=jiantou_up_position[4]&&vcount<=jiantou_down_position[4]
                &&jiantou_down_up[vcount-jiantou_up_position[4]][10-(hcount-jiantou_left_position[4])]==1)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00; 
                end                 
                else if(hcount>=(jiantou_left_position[4]-120)&&hcount<=(jiantou_right_position[4]-120)
                &&vcount>=(jiantou_up_position[4])&&vcount<=(jiantou_down_position[4])
                &&jiantou_down_up[vcount-jiantou_up_position[4]][10-(hcount-jiantou_left_position[4]+120)]==1)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00; 
                end                
                else if(hcount>=jiantou_left_position[5]&&hcount<=jiantou_right_position[5]
                &&vcount>=jiantou_up_position[5]&&vcount<=jiantou_down_position[5]
                &&jiantou_double_down[19-(vcount-jiantou_up_position[5])][(hcount-jiantou_left_position[5])]==1)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00; 
                end                 
                else if(hcount>=(jiantou_left_position[5]-120)&&hcount<=(jiantou_right_position[5]-120)
                &&vcount>=(jiantou_up_position[5])&&vcount<=(jiantou_down_position[5])
                &&jiantou_double_down1[19-(vcount-jiantou_up_position[5])][(hcount-jiantou_left_position[5]+120)]==1)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00; 
                end
                else if(hcount>=jiantou_left_position[6]&&hcount<=jiantou_right_position[6]
                &&vcount>=jiantou_up_position[6]&&vcount<=jiantou_down_position[6]
                &&jiantou_down_left[vcount-jiantou_up_position[6]][10-(hcount-jiantou_left_position[6])]==1)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00; 
                end                 
                else if(hcount>=(jiantou_left_position[6])&&hcount<=(jiantou_right_position[6])
                &&vcount>=(jiantou_up_position[6]+60)&&vcount<=(jiantou_down_position[6]+60)
                &&jiantou_down_left[vcount-jiantou_up_position[6]-60][10-(hcount-jiantou_left_position[6])]==1)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00; 
                end
                else if(hcount>=jiantou_left_position[7]&&hcount<=jiantou_right_position[7]
                &&vcount>=jiantou_up_position[7]&&vcount<=jiantou_down_position[7]
                &&jiantou_double_left[(vcount-jiantou_up_position[7])][19-(hcount-jiantou_left_position[7])]==1)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00; 
                end                 
                else if(hcount>=(jiantou_left_position[7])&&hcount<=(jiantou_right_position[7])
                &&vcount>=(jiantou_up_position[7]+60)&&vcount<=(jiantou_down_position[7]+60)
                &&jiantou_double_left[19-(vcount-jiantou_up_position[7]-60)][19-(hcount-jiantou_left_position[7])]==1)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00; 
                end
                else if((hcount>=470&&hcount<490&&vcount>=335&&vcount<355&&display_jiantou_down[(vcount-335)][19-(hcount-470)]==1)
                ||(hcount>=505&&hcount<516&&vcount>=335&&vcount<345&&jiantou_down_up[vcount-335][10-(hcount-440)]==1)
                ||(hcount>=507&&hcount<512&&vcount>=345&&vcount<355))
                begin
                if(count_light==2'b01&&btn==2'b11)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00;
                end
                else if(count_light==2'b01&&btn==2'b01)
                begin
                r<=3'b111;
                g<=3'b111;
                b<=2'b00;
                end
                else
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;end
                end
                else if(hcount>530&&hcount<550&&vcount>=335&&vcount<355&&display_jiantou_down[(vcount-335)][(hcount-530)]==1)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00;
                end
                else if((hcount>=410&&hcount<430&&vcount>=195&&vcount<215&&display_jiantou_down[19-(vcount-195)][(hcount-410)]==1)
                ||(hcount>=385&&hcount<396&&vcount>=205&&vcount<215&&jiantou_down_down[vcount-205][10-(hcount-385)]==1)
                ||(hcount>=387&&hcount<392&&vcount>=195&&vcount<205))
                begin
                if(count_light==2'b11&&btn==2'b11)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00;
                end
                else if(count_light==2'b11&&btn==2'b01)
                begin
                r<=3'b111;
                g<=3'b111;
                b<=2'b00;
                end
                else
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;end
                end
                else if(hcount>350&&hcount<370&&vcount>=195&&vcount<215&&display_jiantou_down[19-(vcount-195)][19-(hcount-350)]==1)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00;
                end
                else if((hcount>=615&&hcount<635&&vcount>=255&&vcount<275&&display_jiantou_right[(vcount-255)][19-(hcount-615)]==1)
                ||(hcount>=615&&hcount<626&&vcount>=225&&vcount<236&&jiantou_down_left[vcount-225][10-(hcount-615)]==1)
                ||(hcount>=626&&hcount<635&&vcount>=228&&vcount<233))
                begin
                if(count_light==2'b10&&btn2==2'b11)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00;
                end
                else if(count_light==2'b10&&btn2==2'b01)
                begin
                r<=3'b111;
                g<=3'b111;
                b<=2'b00;
                end
                else
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;end
                end
                else if(hcount>615&&hcount<635&&vcount>=195&&vcount<215&&display_jiantou_right[19-(vcount-195)][19-(hcount-615)]==1)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00;
                end
                else if((hcount>=300&&hcount<320&&vcount>=320&&vcount<340&&display_jiantou_right[19-(vcount-320)][(hcount-300)]==1)
                ||(hcount>=309&&hcount<320&&vcount>=350&&vcount<361&&jiantou_down_left[vcount-350][(hcount-309)]==1)
                ||(hcount>=300&&hcount<309&&vcount>=353&&vcount<358))
                begin
                if(count_light==2'b00&&btn2==2'b11)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00;
                end
                else if(count_light==2'b00&&btn2==2'b01)
                begin
                r<=3'b111;
                g<=3'b111;
                b<=2'b00;
                end
                else
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;end
                end
                else if(hcount>300&&hcount<320&&vcount>=380&&vcount<400&&display_jiantou_right[(vcount-380)][(hcount-300)]==1)
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00;
                end
                else if(hcount>=442&&hcount<490&&vcount>=258&&vcount<306&&central[vcount-258][47-(hcount-442)]==1)
                begin
                if(SW==1)
                begin
                r<=3'b111;
                g<=3'b000;
                b<=2'b00;
                end
                else
                begin
                r<=3'b000;
                g<=3'b111;
                b<=2'b00;
                end
                end                                                                                                                                                
                else begin    
                r <= 3'b000;    
                g <= 3'b000;    
                b <= 2'b00;    
                end 
                end      
        end    
        // 每一帧动画之后根据速度值更新方块的位置 

        
        always@(speed_select or rst)
        begin
        if(speed_select==2'b00)
        begin
        speed[3]<=flowspeed;
        speed[1]<=0;speed[2]<=0;speed[0]<=0;
        end
        else if(speed_select==2'b01)
        begin
        speed[0]<=flowspeed;
        speed[1]<=0;speed[2]<=0;speed[3]<=0;
        end
        else if(speed_select==2'b10)
        begin
        speed[1]<=flowspeed;
        speed[2]<=0;speed[0]<=0;speed[3]<=0;
        end
        else if(speed_select==2'b11)
        begin
        speed[2]<=flowspeed;
        speed[1]<=0;speed[3]<=0;speed[0]<=0;
        end                       
        end
        always @ (posedge vs or posedge rst)    
        begin        
            if (rst==0) 
            begin
            car[0]<=29'b00000001111111111111110000000;car[1]<=29'b00000111111111111101111000000;
            car[2]<=29'b00000011111111111110111100000;car[3]<=29'b00001110000000000000001100000;
            car[4]<=29'b00001110000000000000001010000;car[5]<=29'b00001100000000000000000100000;
            car[6]<=29'b00001100000000000000000110000;car[7]<=29'b00011100000000000000000111000;
            car[8]<=29'b00011100000000000000000111000;car[9]<=29'b00011000000000000000000101000;
            car[10]<=29'b00010000000000000000000011000;car[11]<=29'b00111011111111111111111101100;
            car[12]<=29'b01101111111111111111111111110;car[13]<=29'b11111111111111110101111111110;
            car[14]<=29'b11011111111111111111111111111;car[15]<=29'b10100011111111111111111000111;
            car[16]<=29'b11000001111111111111110000111;car[17]<=29'b11100001111111111111110000110;
            car[18]<=29'b11110011111111111111111001111;car[19]<=29'b11111011111111111111111111110;
            car[20]<=29'b01110101111111110101111111110;car[21]<=29'b00111111111111111110111010100;
            car[22]<=29'b00111110000000000000001101100;car[23]<=29'b00001110000000000000001110000;
            car[24]<=29'b00011000000000000000000011000;car[25]<=29'b00000000000000000000000000000;
            car[26]<=29'b00011000000000000000000011000;car[27]<=29'b00000000000000000000000000000;
            car[28]<=29'b00000000000000000000000000000;
            central[0]<=48'b000000000000000000011101101110000000000000000000;central[1]<=48'b000000000000000010111111111111010000000000000000;
            central[2]<=48'b000000000000010111100000000001111010000000000000;central[3]<=48'b000000000000111100000000000000001111000000000000;
            central[4]<=48'b000000000011110000000000000000000011110000000000;central[5]<=48'b000000000110000000000000000000000000011000000000;
            central[6]<=48'b000000001100000000000000000000000000011100000000;central[7]<=48'b000000011000000000000000000000000000000110000000;
            central[8]<=48'b000000110000000000000000000000000000000011000000;central[9]<=48'b000001100000000000000000000000000000000001100000;
            central[10]<=48'b000011100000000000000000000000000000000001110000;central[11]<=48'b000010000000000001000100000000000000000000010000;
            central[12]<=48'b000110000000000001100110000001000000000000011000;central[13]<=48'b001110000000011111111111111001110000000000011100;
            central[14]<=48'b000100000000011111101011111001100000000000001000;central[15]<=48'b001100000000000001100110000001111101110000001100;
            central[16]<=48'b011000000000000010000000000011111111010000000110;central[17]<=48'b001000000000000001111101110011000011000000000100;
            central[18]<=48'b011000000000000110000000110110000010000000000110;central[19]<=48'b110000000000001100000000110001100110000000000011;            
            central[20]<=48'b110000000000011111111100110000111000000000000011;central[21]<=48'b110000000000000010000100110000011100000000000011;
            central[22]<=48'b010000000000000010000110010001101101110000000010;central[23]<=48'b110000000000000011111101100011100111100000000011;
            central[24]<=48'b110000000000000010000000111010000000000000000011;central[25]<=48'b010000000000011111011111111111111111110000000010;
            central[26]<=48'b110000000000000000000000000000000000000000000011;central[27]<=48'b110000000000000000000000000000000000000000000011;
            central[28]<=48'b110000000000000011001111101111110100000000000011;central[29]<=48'b011000000000000000000000000000000000000000000110;
            central[30]<=48'b001000000000000000000000000000000000000000000100;central[31]<=48'b011000000000000011111111111111111000000000000110;
            central[32]<=48'b001100000000000000000000000000000000000000001100;central[33]<=48'b000100000000000000000000000000000000000000001000;
            central[34]<=48'b001110000000000001111111111111111000000000011100;central[35]<=48'b000110000000000011000000000000001100000000011000;
            central[36]<=48'b000010000000000011000000000000000100000000010000;central[37]<=48'b000011100000000011011111111111111100000001110000;
            central[38]<=48'b000001100000000010000000000000001000000001100000;central[39]<=48'b000000110000000000000000000000000000000011000000;
            central[40]<=48'b000000011000000000000000000000000000000110000000;central[41]<=48'b000000001110000000000000000000000000011100000000;
            central[42]<=48'b000000000110000000000000000000000000011000000000;central[43]<=48'b000000000011110000000000000000000011110000000000;            
            central[44]<=48'b000000000000111100000000000000001111000000000000;central[45]<=48'b000000000000011111100000000001111110000000000000;
            central[46]<=48'b000000000000000010111111111111010000000000000000;central[47]<=48'b000000000000000000011101101110000000000000000000;
            display_jiantou_down[0]<=20'b00000000000000000000;
            display_jiantou_down[1]<=20'b00000001000000000000;
            display_jiantou_down[2]<=20'b00000011000000000000;
            display_jiantou_down[3]<=20'b00000111000000000000;
            display_jiantou_down[4]<=20'b00001111000000000000; 
            display_jiantou_down[5]<=20'b00011111000000000000;; 
            display_jiantou_down[6]<=20'b00111111100000000000; 
            display_jiantou_down[7]<=20'b01111111110000000000; 
            display_jiantou_down[8]<=20'b11111111111000000000;
            display_jiantou_down[9]<=20'b01111111111100000000;
            display_jiantou_down[10]<=20'b00111111111100000000; 
            display_jiantou_down[11]<=20'b00011110111110000000; 
            display_jiantou_down[12]<=20'b00001110011111000000; 
            display_jiantou_down[13]<=20'b00000110001111100000; 
            display_jiantou_down[14]<=20'b00000010000011111000; 
            display_jiantou_down[15]<=20'b00000000000001111100; 
            display_jiantou_down[16]<=20'b00000000000001111100;
            display_jiantou_down[17]<=20'b00000000000001111100; 
            display_jiantou_down[18]<=20'b00000000000001111100; 
            display_jiantou_down[19]<=20'b00000000000001111100; 
            
            display_jiantou_right[0]<=20'b00000000000000000000;
            display_jiantou_right[1]<=20'b00000000000000000000;
            display_jiantou_right[2]<=20'b00000000000000000000;
            display_jiantou_right[3]<=20'b00000000000000111111;
            display_jiantou_right[4]<=20'b00000000000001111111; 
            display_jiantou_right[5]<=20'b00000000000011111111;; 
            display_jiantou_right[6]<=20'b00000000000111111111; 
            display_jiantou_right[7]<=20'b00000000001111111111; 
            display_jiantou_right[8]<=20'b00000000011111100000;
            display_jiantou_right[9]<=20'b00000000111111000000;
           display_jiantou_right[10]<=20'b00000001111110000000; 
           display_jiantou_right[11]<=20'b00000011111100000000; 
           display_jiantou_right[12]<=20'b01111111111111110000; 
           display_jiantou_right[13]<=20'b00111111111111100000; 
           display_jiantou_right[14]<=20'b00011111111111000000; 
           display_jiantou_right[15]<=20'b00001111111110000000; 
           display_jiantou_right[16]<=20'b00000111111100000000;
           display_jiantou_right[17]<=20'b00000011111000000000; 
           display_jiantou_right[18]<=20'b00000001110000000000; 
           display_jiantou_right[19]<=20'b00000000100000000000;
           
           
           
            jiantou_down_up[0]<=11'b00000100000;
            jiantou_down_up[1]<=11'b00001110000;
            jiantou_down_up[2]<=11'b00011111000;
            jiantou_down_up[3]<=11'b00111111100;
            jiantou_down_up[4]<=11'b01111111110;
            jiantou_down_up[5]<=11'b00011111000;
            jiantou_down_up[6]<=11'b00011111000;
            jiantou_down_up[7]<=11'b00011111000;
            jiantou_down_up[8]<=11'b00011111000;
            jiantou_down_up[9]<=11'b00011111000;
            jiantou_down_up[10]<=11'b00011111000;              
            jiantou_down_down[0]<=11'b00011111000;
            jiantou_down_down[1]<=11'b00011111000;
            jiantou_down_down[2]<=11'b00011111000;
            jiantou_down_down[3]<=11'b00011111000;
            jiantou_down_down[4]<=11'b00011111000;
            jiantou_down_down[5]<=11'b00011111000; 
            jiantou_down_down[6]<=11'b01111111110;
            jiantou_down_down[7]<=11'b00111111100;
            jiantou_down_down[8]<=11'b00011111000;
            jiantou_down_down[9]<=11'b00001110000; 
            jiantou_down_down[10]<=11'b00000100000;
            
            jiantou_down_left[0]<=11'b00000000000;
            jiantou_down_left[1]<=11'b00001000000;
            jiantou_down_left[2]<=11'b00011000000;
            jiantou_down_left[3]<=11'b00111111111;
            jiantou_down_left[4]<=11'b01111111111;
            jiantou_down_left[5]<=11'b11111111111; 
            jiantou_down_left[6]<=11'b01111111111;
            jiantou_down_left[7]<=11'b00111111111;
            jiantou_down_left[8]<=11'b00011000000;
            jiantou_down_left[9]<=11'b00001000000; 
            jiantou_down_left[10]<=11'b00000000000;
            
            jiantou_down_right[0]<=11'b00000000000;
            jiantou_down_right[1]<=11'b00000010000;
            jiantou_down_right[2]<=11'b00000011000;
            jiantou_down_right[3]<=11'b11111111100;
            jiantou_down_right[4]<=11'b11111111110;
            jiantou_down_right[5]<=11'b11111111111; 
            jiantou_down_right[6]<=11'b11111111110;
            jiantou_down_right[7]<=11'b11111111100;
            jiantou_down_right[8]<=11'b00000011000;
            jiantou_down_right[9]<=11'b00000010000; 
            jiantou_down_right[10]<=11'b00000000000;   
            
            
            
                                         
            jiantou_double_left[0]<=20'b00000000000100000000;
            jiantou_double_left[1]<=20'b00000000001110000000; 
            jiantou_double_left[2]<=20'b00000000011111000000; 
            jiantou_double_left[3]<=20'b00000000111111100000; 
            jiantou_double_left[4]<=20'b00000001111111110000; 
            jiantou_double_left[5]<=20'b00000000011111000000; 
            jiantou_double_left[6]<=20'b00000000111110000000; 
            jiantou_double_left[7]<=20'b00000001111100000000; 
            jiantou_double_left[8]<=20'b00000011111000010000;
            jiantou_double_left[9]<=20'b00000111110000011000;
           jiantou_double_left[10]<=20'b11111111111111111100; 
           jiantou_double_left[11]<=20'b11111111111111111110; 
           jiantou_double_left[12]<=20'b11111111111111111111; 
           jiantou_double_left[13]<=20'b11111111111111111110; 
           jiantou_double_left[14]<=20'b11111111111111111100; 
           jiantou_double_left[15]<=20'b00000000000000011000; 
           jiantou_double_left[16]<=20'b00000000000000010000;
           jiantou_double_left[17]<=20'b00000000000000000000; 
           jiantou_double_left[18]<=20'b00000000000000000000; 
           jiantou_double_left[19]<=20'b00000000000000000000;               
           
           jiantou_double_right[0]<=20'b00001000000000000000;
           jiantou_double_right[1]<=20'b00011000000000000000;
           jiantou_double_right[2]<=20'b00111111111111111111;
           jiantou_double_right[3]<=20'b01111111111111111111;
           jiantou_double_right[4]<=20'b11111111111111111111; 
           jiantou_double_right[5]<=20'b01111111111111111111;; 
           jiantou_double_right[6]<=20'b00111111111111111111; 
           jiantou_double_right[7]<=20'b00011000001111100000; 
           jiantou_double_right[8]<=20'b00001000011111000000;
           jiantou_double_right[9]<=20'b00000000111110000000;
          jiantou_double_right[10]<=20'b00000001111100000000; 
          jiantou_double_right[11]<=20'b00000011111000000000; 
          jiantou_double_right[12]<=20'b00001111111110000000; 
          jiantou_double_right[13]<=20'b00000111111100000000; 
          jiantou_double_right[14]<=20'b00000011111000000000; 
          jiantou_double_right[15]<=20'b00000001110000000000; 
          jiantou_double_right[16]<=20'b00000000100000000000;
          jiantou_double_right[17]<=20'b00000000000000000000; 
          jiantou_double_right[18]<=20'b00000000000000000000; 
          jiantou_double_right[19]<=20'b00000000000000000000;                             
          
          
          
          
          
          
          jiantou_double_left1[0]<=20'b00000000000000000000;
          jiantou_double_left1[1]<=20'b00000000000000000000; 
          jiantou_double_left1[2]<=20'b00000000000000000000; 
          jiantou_double_left1[3]<=20'b00000000000000010000; 
          jiantou_double_left1[4]<=20'b00000000000000011000; 
          jiantou_double_left1[5]<=20'b11111111111111111100; 
          jiantou_double_left1[6]<=20'b11111111111111111110; 
          jiantou_double_left1[7]<=20'b11111111111111111111; 
          jiantou_double_left1[8]<=20'b11111111111111111110;
          jiantou_double_left1[9]<=20'b11111111111111111100;
         jiantou_double_left1[10]<=20'b00000111110000011000; 
         jiantou_double_left1[11]<=20'b00000011111000010000; 
         jiantou_double_left1[12]<=20'b00000001111100000000; 
         jiantou_double_left1[13]<=20'b00000000111110000000; 
         jiantou_double_left1[14]<=20'b00000000011111000000; 
         jiantou_double_left1[15]<=20'b00000011111111111000; 
         jiantou_double_left1[16]<=20'b00000001111111100000;
         jiantou_double_left1[17]<=20'b0000000011111100000; 
         jiantou_double_left1[18]<=20'b00000000001110000000; 
         jiantou_double_left1[19]<=20'b00000000000100000000;               
         
         jiantou_double_right1[0]<=20'b00000000000000000000;
         jiantou_double_right1[1]<=20'b00000000000000000000;
         jiantou_double_right1[2]<=20'b00000000000000000000;
         jiantou_double_right1[3]<=20'b00000000100000000000;
         jiantou_double_right1[4]<=20'b00000001110000000000; 
         jiantou_double_right1[5]<=20'b00000011111000000000;; 
         jiantou_double_right1[6]<=20'b00000111111100000000; 
         jiantou_double_right1[7]<=20'b00001111111110000000; 
         jiantou_double_right1[8]<=20'b00000011110000000000;
         jiantou_double_right1[9]<=20'b00000001111000000000;
        jiantou_double_right1[10]<=20'b0000000011110000000; 
        jiantou_double_right1[11]<=20'b00001000011110000000; 
        jiantou_double_right1[12]<=20'b00011000001111000000; 
        jiantou_double_right1[13]<=20'b00111111111111111111; 
        jiantou_double_right1[14]<=20'b01111111111111111111; 
        jiantou_double_right1[15]<=20'b11111111111111111111;
        jiantou_double_right1[16]<=20'b01111111111111111111; 
        jiantou_double_right1[17]<=20'b00111111111111111111; 
        jiantou_double_right1[18]<=20'b00011000000000000000;               
        jiantou_double_right1[19]<=20'b00001000000000000000;                
                      
          jiantou_double_up[0]<=20'b00000000000001111100;
          jiantou_double_up[1]<=20'b00000000000001111100;
          jiantou_double_up[2]<=20'b00000000000001111100;
          jiantou_double_up[3]<=20'b00000000000001111100;
          jiantou_double_up[4]<=20'b00000001000001111100; 
          jiantou_double_up[5]<=20'b00000011000011111100;
          jiantou_double_up[6]<=20'b00000111000111111100; 
          jiantou_double_up[7]<=20'b00001111001111111100; 
          jiantou_double_up[8]<=20'b00011111011111111100;
          jiantou_double_up[9]<=20'b00111111111111111100;
         jiantou_double_up[10]<=20'b01111111111101111100; 
         jiantou_double_up[11]<=20'b11111111111001111100; 
         jiantou_double_up[12]<=20'b01111111110001111100; 
         jiantou_double_up[13]<=20'b00111111100001111100; 
         jiantou_double_up[14]<=20'b00011111000001111100; 
         jiantou_double_up[15]<=20'b00001111000111111111; 
         jiantou_double_up[16]<=20'b00000111000011111110;
         jiantou_double_up[17]<=20'b00000011000001111100; 
         jiantou_double_up[18]<=20'b00000001000000111000; 
         jiantou_double_up[19]<=20'b00000000000000010000;               
                      

          jiantou_double_up1[0]<=20'b00111110000000000000;
          jiantou_double_up1[1]<=20'b00111110000000000000;
          jiantou_double_up1[2]<=20'b00111110000000000000;
          jiantou_double_up1[3]<=20'b00111110000000000000;
          jiantou_double_up1[4]<=20'b00111110000000000000; 
          jiantou_double_up1[5]<=20'b00111111000000000000;
          jiantou_double_up1[6]<=20'b00111111100001000000; 
          jiantou_double_up1[7]<=20'b00111111110001100000; 
          jiantou_double_up1[8]<=20'b00111111111001110000;
          jiantou_double_up1[9]<=20'b00111111111101111000;
         jiantou_double_up1[10]<=20'b00111110111111111100; 
         jiantou_double_up1[11]<=20'b00111110011111111110; 
         jiantou_double_up1[12]<=20'b00111110001111111111; 
         jiantou_double_up1[13]<=20'b00111110000111111110; 
         jiantou_double_up1[14]<=20'b00111110000011111100; 
         jiantou_double_up1[15]<=20'b11111111100001111000; 
         jiantou_double_up1[16]<=20'b01111111000001110000;
         jiantou_double_up1[17]<=20'b00111110000001100000; 
         jiantou_double_up1[18]<=20'b00011100000001000000; 
         jiantou_double_up1[19]<=20'b00001000000000000000;           
             jiantou_double_down[0]<=20'b00000000000000010000;
             jiantou_double_down[1]<=20'b00000000000000111000;
             jiantou_double_down[2]<=20'b00000010000001111100;
             jiantou_double_down[3]<=20'b00000110000011111110;
             jiantou_double_down[4]<=20'b00001110000111111111; 
             jiantou_double_down[5]<=20'b00011111000001111100;; 
             jiantou_double_down[6]<=20'b00111111100001111100; 
             jiantou_double_down[7]<=20'b01111111110001111100; 
             jiantou_double_down[8]<=20'b11111111111001111100;
             jiantou_double_down[9]<=20'b01111111111101111100;
             jiantou_double_down[10]<=20'b00111110111111111100; 
             jiantou_double_down[11]<=20'b00011110011111111100; 
             jiantou_double_down[12]<=20'b00001110001111111100; 
             jiantou_double_down[13]<=20'b00000110000111111100; 
             jiantou_double_down[14]<=20'b00000010000011111100; 
             jiantou_double_down[15]<=20'b00000000000001111100; 
             jiantou_double_down[16]<=20'b00000000000001111100;
             jiantou_double_down[17]<=20'b00000000000001111100; 
             jiantou_double_down[18]<=20'b00000000000001111100; 
             jiantou_double_down[19]<=20'b00000000000001111100;                        
            jiantou_double_down1[0]<=20'b00001000000000000000;
            jiantou_double_down1[1]<=20'b00011100000001000000;
            jiantou_double_down1[2]<=20'b00111110000001100000;
            jiantou_double_down1[3]<=20'b01111111000001110000;
            jiantou_double_down1[4]<=20'b11111111100001111000; 
            jiantou_double_down1[5]<=20'b00111110000011111100;
            jiantou_double_down1[6]<=20'b00111110000111111110;
            jiantou_double_down1[7]<=20'b00111110001111111111; 
            jiantou_double_down1[8]<=20'b00111110011111111110;
            jiantou_double_down1[9]<=20'b00111110111111111100;
            jiantou_double_down1[10]<=20'b00111111111101111000; 
            jiantou_double_down1[11]<=20'b00111111111001110000; 
            jiantou_double_down1[12]<=20'b00111111110001100000; 
            jiantou_double_down1[13]<=20'b00111111100001000000; 
            jiantou_double_down1[14]<=20'b00111111000000000000; 
            jiantou_double_down1[15]<=20'b00111110000000000000; 
            jiantou_double_down1[16]<=20'b00111110000000000000;
            jiantou_double_down1[17]<=20'b00111110000000000000; 
            jiantou_double_down1[18]<=20'b00111110000000000000; 
            jiantou_double_down1[19]<=20'b00111110000000000000;               
            jiantou_up_position[0]<=416;
            jiantou_down_position[0]<=427;
            jiantou_left_position[0]<=276;
            jiantou_right_position[0]<=287;
            jiantou_up_position[1]<=416;
            jiantou_down_position[1]<=436;
            jiantou_left_position[1]<=516;
            jiantou_right_position[1]<=536;
            jiantou_up_position[2]<=370;
            jiantou_down_position[2]<=381;
            jiantou_left_position[2]<=715;
            jiantou_right_position[2]<=726;
            jiantou_up_position[3]<=235;
            jiantou_down_position[3]<=255;
            jiantou_left_position[3]<=715;
            jiantou_right_position[3]<=735;
            jiantou_up_position[4]<=104;
            jiantou_down_position[4]<=115;
            jiantou_left_position[4]<=637;
            jiantou_right_position[4]<=648;
            jiantou_up_position[5]<=95;
            jiantou_down_position[5]<=114;
            jiantou_left_position[5]<=400;
            jiantou_right_position[5]<=419;
            jiantou_up_position[6]<=162;
            jiantou_down_position[6]<=173;
            jiantou_left_position[6]<=214;
            jiantou_right_position[6]<=225;
            jiantou_up_position[7]<=305;
            jiantou_down_position[7]<=324;
            jiantou_left_position[7]<=205;
            jiantou_right_position[7]<=224;                                                               
            down_car_position_up[0]<=418;
            down_car_position_down[0]<=421;
            down_car_position_left[0]<=488;
            down_car_position_right[0]<=491;
            car_turn_left_up[0]<=418;
            car_turn_left_down[0]<=421;
            car_turn_left_left[0]<=471;
            car_turn_left_right[0]<=474;
            up_pos[0] <= 390;    
            down_pos[0] <= 410;    
            left_pos[0] <= 500;    
            right_pos[0] <= 520;   
            up_pos[1] <= 225;    
            down_pos[1] <= 245;    
            left_pos[1] <= 663;    
            right_pos[1] <= 683;        
            up_pos[2] <= 140;    
            down_pos[2] <= 160;    
            left_pos[2] <= 380;    
            right_pos[2] <=400 ; 
            up_pos[3] <= 350;    
            down_pos[3] <= 370;    
            left_pos[3] <= 243;    
            right_pos[3] <= 263;                                 
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
            else if (down_car_position_up[0] <= UP_BOUND)  
            begin
            down_car_position_up[0]<=418;
            down_car_position_down[0]<=421;
            down_car_position_left[0]<=488;
            down_car_position_right[0]<=491;  
            end
            else if((btn==2'b11&&count_light==2'b01)||((btn==2'b00||btn==2'b01)&&(down_car_position_up[0]<black_line_up[0]||car_turn_left_up[0]<black_line_up[0])))
            begin
            if((btn==2'b11&&count_light==2'b01)||((btn==2'b00||btn==2'b01)&&(down_car_position_up[0]<black_line_up[0])))
            begin
            down_car_position_up[0]<=down_car_position_up[0]-1-speed[0];
            down_car_position_down[0]<=down_car_position_down[0]-1-speed[0];
            down_car_position_left[0]<=down_car_position_left[0];
            down_car_position_right[0]<=down_car_position_right[0]; 
            end
            if(car_turn_left_up[0]>390)
            begin
            car_turn_left_up[0]<=car_turn_left_up[0]-1;
            car_turn_left_down[0]<=car_turn_left_down[0]-1;
            car_turn_left_left[0]<=car_turn_left_left[0];
            car_turn_left_right[0]<=car_turn_left_right[0];
            end
            else if(car_turn_left_up[0]<=390&&car_turn_left_up[0]>240)
            begin
            car_turn_left_up[0]<=car_turn_left_up[0]-1;
            car_turn_left_down[0]<=car_turn_left_down[0]-1;
            car_turn_left_left[0]<=car_turn_left_left[0]-1;
            car_turn_left_right[0]<=car_turn_left_right[0]-1;              
            end
            else if(car_turn_left_up[0]<=240&&car_turn_left_left[0]>80)
            begin
            car_turn_left_up[0]<=car_turn_left_up[0];
            car_turn_left_down[0]<=car_turn_left_down[0];
            car_turn_left_left[0]<=car_turn_left_left[0]-1;
            car_turn_left_right[0]<=car_turn_left_right[0]-1;      
            end 
            else if(car_turn_left_left[0]<=80)
            begin
            car_turn_left_up[0]<=418;
            car_turn_left_down[0]<=421;
            car_turn_left_left[0]<=471;
            car_turn_left_right[0]<=474;              
            end                                
            end 
                 
        end    

                always @ (posedge vs or posedge rst)    
                begin
                if (rst==0)
                begin
                car_turn_right_up[0]<=448; 
                car_turn_right_down[0]<=451;
                car_turn_right_left[0]<=670;
                car_turn_right_right[0]<=673;              
                end 
                else if(car_turn_right_up[0]>385)
                begin
                car_turn_right_up[0]<=car_turn_right_up[0]-2; 
                car_turn_right_down[0]<=car_turn_right_down[0]-2;
                car_turn_right_left[0]<=car_turn_right_left[0]+1;
                car_turn_right_right[0]<=car_turn_right_right[0]+1;              
                end 
                else if(car_turn_right_up[0]<=385&&car_turn_right_left[0]<=733)
                begin
                car_turn_right_up[0]<=car_turn_right_up[0]; 
                car_turn_right_down[0]<=car_turn_right_down[0];
                car_turn_right_left[0]<=car_turn_right_left[0]+1;
                car_turn_right_right[0]<=car_turn_right_right[0]+1;                  
                end
                else if(car_turn_right_left[0]>733)
                begin
                car_turn_right_up[0]<=448; 
                car_turn_right_down[0]<=451;
                car_turn_right_left[0]<=670;
                car_turn_right_right[0]<=673;           
                end 
                end
                
                
                
                always @ (posedge vs or posedge rst)    
                begin
                if (rst==0)
                begin
                car_turn_right_up[1]<=135; 
                car_turn_right_down[1]<=138;
                car_turn_right_left[1]<=715;
                car_turn_right_right[1]<=718;              
                end 
                else if(car_turn_right_left[1]>643)
                begin
                car_turn_right_up[1]<=car_turn_right_up[1]-1; 
                car_turn_right_down[1]<=car_turn_right_down[1]-1;
                car_turn_right_left[1]<=car_turn_right_left[1]-2;
                car_turn_right_right[1]<=car_turn_right_right[1]-2;              
                end 
                else if(car_turn_right_left[1]<=643&&car_turn_right_up[1]>=30)
                begin
                car_turn_right_up[1]<=car_turn_right_up[1]-1; 
                car_turn_right_down[1]<=car_turn_right_down[1]-1;
                car_turn_right_left[1]<=car_turn_right_left[1];
                car_turn_right_right[1]<=car_turn_right_right[1];                  
                end
                else if(car_turn_right_up[1]<30)
                begin
                car_turn_right_up[1]<=135; 
                car_turn_right_down[1]<=138;
                car_turn_right_left[1]<=715;
                car_turn_right_right[1]<=718;          
                end 
                end         
                     
                always @ (posedge vs or posedge rst)    
                begin
                if (rst==0)
                begin
                car_turn_right_up[2]<=112; 
                car_turn_right_down[2]<=115;
                car_turn_right_left[2]<=240;
                car_turn_right_right[2]<=243;              
                end 
                else if(car_turn_right_up[2]<168)
                begin
                car_turn_right_up[2]<=car_turn_right_up[2]+2; 
                car_turn_right_down[2]<=car_turn_right_down[2]+2;
                car_turn_right_left[2]<=car_turn_right_left[2]-1;
                car_turn_right_right[2]<=car_turn_right_right[2]-1;              
                end 
                else if(car_turn_right_up[2]>=168&&car_turn_right_left[2]>=30)
                begin
                car_turn_right_up[2]<=car_turn_right_up[2]; 
                car_turn_right_down[2]<=car_turn_right_down[2];
                car_turn_right_left[2]<=car_turn_right_left[2]-1;
                car_turn_right_right[2]<=car_turn_right_right[2]-1;                  
                end
                else if(car_turn_right_left[2]<30)
                begin
                car_turn_right_up[2]<=112; 
                car_turn_right_down[2]<=115;
                car_turn_right_left[2]<=240;
                car_turn_right_right[2]<=243;          
                end 
                end       
                always @ (posedge vs or posedge rst)    
                begin
                if (rst==0)
                begin
                car_turn_right_up[3]<=400; 
                car_turn_right_down[3]<=403;
                car_turn_right_left[3]<=220;
                car_turn_right_right[3]<=223;              
                end 
                else if(car_turn_right_left[3]<296)
                begin
                car_turn_right_up[3]<=car_turn_right_up[3]+1; 
                car_turn_right_down[3]<=car_turn_right_down[3]+1;
                car_turn_right_left[3]<=car_turn_right_left[3]+2;
                car_turn_right_right[3]<=car_turn_right_right[3]+2;              
                end 
                else if(car_turn_right_left[3]>=296&&car_turn_right_up[3]<=530)
                begin
                car_turn_right_up[3]<=car_turn_right_up[3]+1; 
                car_turn_right_down[3]<=car_turn_right_down[3]+1;
                car_turn_right_left[3]<=car_turn_right_left[3];
                car_turn_right_right[3]<=car_turn_right_right[3];                  
                end
                else if(car_turn_right_up[3]>530)
                begin
                car_turn_right_up[3]<=400; 
                car_turn_right_down[3]<=403;
                car_turn_right_left[3]<=220;
                car_turn_right_right[3]<=223;         
                end 
                
        end
        always@(posedge vs or posedge rst)
        begin
        if(rst==0)
        begin
        car_straight_up[0]<=440;
        car_straight_left[0]<=510;
        car_leftturn_up[0]<=440;
        car_leftturn_left[0]<=475;
        end
        else if(car_straight_up[0]<=UP_BOUND)
        begin
        car_straight_up[0]<=440;
        car_straight_left[0]<=510;
        end//||car_leftturn_up[0]<black_line_up[0]
        else if((btn==2'b11&&count_light==2'b01)||((btn==2'b00||btn==2'b01)&&(car_straight_up[0]<black_line_up[0])))
        begin
       // if(car_straight_up[0]<black_line_up[0])begin
        car_straight_up[0]<=car_straight_up[0]-1-speed[0];
        //end
        //if(car_leftturn_up[0]>390)
        //begin
        //car_leftturn_up[0]<=car_leftturn_up[0]-1;
        //car_leftturn_left[0]<=car_leftturn_left[0];
        //end
        //else if(car_leftturn_up[0]<=390&&car_leftturn_up[0]>240)
        //begin
        //car_leftturn_up[0]<=car_leftturn_up[0]-1;
       // car_leftturn_left[0]<=car_leftturn_left[0]-1;            
        //end
       // else if(car_leftturn_up[0]<=240&&car_leftturn_left[0]>80)
      //  begin
      //  car_leftturn_up[0]<=car_leftturn_up[0];
      //  car_leftturn_left[0]<=car_leftturn_left[0]-1;   
      //  end 
     //   else if(car_leftturn_left[0]<=80)
       // begin
      //  car_leftturn_up[0]<=440;
      //  car_leftturn_left[0]<=475;           
       // end
        end
        end 
        always@(posedge vs or posedge rst)
        begin
        if(rst==0)
        begin
        car_straight_up[1]<=215;
        car_straight_left[1]<=745;
        car_leftturn_up[1]<=247;
        car_leftturn_left[1]<=745;
        end
        else if(car_straight_left[1]<=LEFT_BOUND)
        begin
        car_straight_up[1]<=215;
        car_straight_left[1]<=745;
        end//||car_leftturn_left[1]<black_line_up[3]
        else if((btn2==2'b11&&count_light==2'b10)||((btn2==2'b00||btn2==2'b01)&&(car_straight_left[1]<black_line_left[3])))
        begin
        //if(car_straight_left[1]<black_line_left[3])
        //begin
        car_straight_left[1]<=car_straight_left[1]-1-speed[1];    
        //end
        
       // if(car_leftturn_left[1]>690)
     //   begin
     //   car_leftturn_up[1]<=car_turn_left_up[1];
     //   car_leftturn_left[1]<=car_leftturn_left[1]-1;             
     //   end
       // else if(car_leftturn_left[1]<=690&&car_leftturn_up[1]<=403&&car_leftturn_left[1]>355)
      //  begin
      //  car_leftturn_up[1]<=car_leftturn_up[1]+1;
      //  car_leftturn_left[1]<=car_leftturn_left[1]-2;
      //  end
      //  else if(car_leftturn_up[1]<600&&car_leftturn_left[1]<=355)
      //  begin
      //  car_leftturn_up[1]<=car_leftturn_up[1]+1;
       // car_leftturn_left[1]<=car_leftturn_left[1];
      //  end
      //  else if(car_leftturn_up[1]>=600)
      //  begin
     //   car_leftturn_up[1]<=247;
     //   car_leftturn_left[1]<=745;
     //   end 
        end
        end 
        
        always@(posedge vs or posedge rst)
        begin
        if(rst==0)
        begin
        car_straight_up[2]<=62;
        car_straight_left[2]<=398;
        car_leftturn_up[2]<=62;
        car_leftturn_left[2]<=398+35; 
        end
        else if(car_straight_up[2]>=DOWN_BOUND)
        begin
        car_straight_up[2]<=62;
        car_straight_left[2]<=398;
        end//||car_leftturn_up[2]+29<black_line_up[1]
        else if((btn==2'b11&&count_light==2'b11)||((btn==2'b00||btn==2'b01)&&(car_straight_up[2]+29>black_line_up[1])))
        begin
     //   if(car_straight_up[2]+29>black_line_up[1])begin
        car_straight_up[2]<=car_straight_up[2]+1+speed[2];
      //  end
        
       // if(car_turn_left_up[2]<190)
     //   begin
     //   car_leftturn_up[2]<=car_leftturn_up[2]+1;
     //   car_leftturn_left[2]<=car_leftturn_left[2];   
     //   end
     //   else if(car_leftturn_up[2]>=190&&car_leftturn_left[2]<692)
     //   begin
      //  car_leftturn_up[2]<=car_leftturn_up[2]+1;
     //   car_leftturn_left[2]<=car_leftturn_left[2]+2;         
     //   end
     //   else if(car_leftturn_left[2]>=692&&car_leftturn_left[2]+29<RIGHT_BOUND)
      //  begin
      //  car_leftturn_up[2]<=car_leftturn_up[2];
      //  car_leftturn_left[2]<=car_leftturn_left[2]+1;              
      //  end
      //  else if(car_leftturn_left[2]+29>=RIGHT_BOUND)
     //   begin
     //   car_leftturn_up[2]<=62;
     //   car_leftturn_left[2]<=398+35;        
     //   end  
        
        
        
        
        
        end
        end 
        
        always@(posedge vs or posedge rst)
        begin
        if(rst==0)
        begin
        car_straight_up[3]<=312;
        car_straight_left[3]<=154;
        car_leftturn_up[3]<=312-38-29;
        car_leftturn_left[3]<=154;
        end
        else if(car_straight_left[3]>=RIGHT_BOUND)
        begin
        car_straight_up[3]<=312;
        car_straight_left[3]<=154;
        end
        else if((btn2==2'b11&&count_light==2'b00)||((btn2==2'b00||btn2==2'b01)&&(car_straight_left[3]+29>black_line_right[2])))
        begin//||car_leftturn_left[3]+29<black_line_right[2]
      //  if(car_straight_left[3]+29>black_line_right[2])
        begin
        car_straight_left[3]<=car_straight_left[3]+1+speed[3];
        end
        
       // if(car_turn_left_up[3]>148)
      //  begin
      //  car_leftturn_up[3]<=car_leftturn_up[3]-1;  
      //  car_leftturn_left[3]<=car_leftturn_left[3]+2; 
       // end
      //  else if(car_leftturn_up[3]<=148&&car_leftturn_up[3]>=90)
      //  begin
      //  car_leftturn_up[3]<=car_leftturn_up[3]-1;  
       // car_leftturn_left[3]<=car_leftturn_left[3]; 
       // end
       // else if(car_leftturn_up[3]<90)
       // begin
       // car_leftturn_up[3]<=312-38-29;
       // car_leftturn_left[3]<=154;
       // end
       
        end
        end 
               
        always @ (posedge vs or posedge rst)    
        begin
        if(rst==0)
        begin
        right_car_position_up[0]<=212;
        right_car_position_down[0]<=215;
        right_car_position_left[0]<=715;
        right_car_position_right[0]<=718;
        car_turn_left_up[1]<=240;
        car_turn_left_down[1]<=243;
        car_turn_left_left[1]<=715;
        car_turn_left_right[1]<=718;       
        end
        else if(right_car_position_right[0]<LEFT_BOUND)
        begin
        right_car_position_up[0]<=212;
        right_car_position_down[0]<=215;
        right_car_position_left[0]<=715;
        right_car_position_right[0]<=718;   
        end  
        else if((btn2==2'b11&&count_light==2'b10)||((btn2==2'b00||btn2==2'b01)&&(right_car_position_left[0]<black_line_left[3]||car_turn_left_left[1]<black_line_left[3])))
        begin
        if((btn2==2'b11&&count_light==2'b10)||((btn2==2'b00||btn2==2'b01)&&(right_car_position_left[0]<black_line_left[3])))
        begin
        right_car_position_up[0]<=right_car_position_up[0];
        right_car_position_down[0]<=right_car_position_down[0];
        right_car_position_left[0]<=right_car_position_left[0]-1-speed[1];
        right_car_position_right[0]<=right_car_position_right[0]-1-speed[1]; 
        end
        if(car_turn_left_left[1]>690)
        begin
        car_turn_left_up[1]<=car_turn_left_up[1];
        car_turn_left_down[1]<=car_turn_left_down[1];
        car_turn_left_left[1]<=car_turn_left_left[1]-1;
        car_turn_left_right[1]<=car_turn_left_right[1]-1;              
        end
        else if(car_turn_left_left[1]<=690&&car_turn_left_up[1]<=403&&car_turn_left_left[1]>355)
        begin
        car_turn_left_up[1]<=car_turn_left_up[1]+1;
        car_turn_left_down[1]<=car_turn_left_down[1]+1;
        car_turn_left_left[1]<=car_turn_left_left[1]-2;
        car_turn_left_right[1]<=car_turn_left_right[1]-2;
        end
        else if(car_turn_left_up[1]<600&&right_car_position_left[1]<=355)
        begin
        car_turn_left_up[1]<=car_turn_left_up[1]+1;
        car_turn_left_down[1]<=car_turn_left_down[1]+1;
        car_turn_left_left[1]<=car_turn_left_left[1];
        car_turn_left_right[1]<=car_turn_left_right[1];
        end
        else if(car_turn_left_up[1]>=600)
        begin
        car_turn_left_up[1]<=240;
        car_turn_left_down[1]<=243;
        car_turn_left_left[1]<=715;
        car_turn_left_right[1]<=718; 
        end
        end
        end
        always @ (posedge vs or posedge rst)    
        begin
        if(rst==0)
        begin
        left_car_position_up[0]<=339;
        left_car_position_down[0]<=342;
        left_car_position_left[0]<=214;
        left_car_position_right[0]<=217; 
        car_turn_left_up[3]<=290;  
        car_turn_left_down[3]<=293;
        car_turn_left_right[3]<=217;
        car_turn_left_left[3]<=214;               
        end
        else if(left_car_position_right[0]>RIGHT_BOUND)
        begin
        left_car_position_up[0]<=339;
        left_car_position_down[0]<=342;
        left_car_position_left[0]<=214;
        left_car_position_right[0]<=217; 
        end  
        else if((btn2==2'b11&&count_light==2'b00)||((btn2==2'b00||btn2==2'b01)&&(left_car_position_right[0]>black_line_right[2]||car_turn_left_right[3]>black_line_right[2])))
        begin
        if((btn2==2'b11&&count_light==2'b00)||((btn2==2'b00||btn2==2'b01)&&(left_car_position_right[0]>black_line_right[2])))
        begin
        left_car_position_up[0]<=left_car_position_up[0];
        left_car_position_down[0]<=left_car_position_down[0];
        left_car_position_left[0]<=left_car_position_left[0]+1+speed[3];
        left_car_position_right[0]<=left_car_position_right[0]+1+speed[3]; 
        end
        if(car_turn_left_up[3]>148)
        begin
        car_turn_left_up[3]<=car_turn_left_up[3]-1;  
        car_turn_left_down[3]<=car_turn_left_down[3]-1;
        car_turn_left_right[3]<=car_turn_left_right[3]+2;
        car_turn_left_left[3]<=car_turn_left_left[3]+2; 
        end
        else if(car_turn_left_up[3]<=148&&car_turn_left_up[3]>=90)
        begin
        car_turn_left_up[3]<=car_turn_left_up[3]-1;  
        car_turn_left_down[3]<=car_turn_left_down[3]-1;
        car_turn_left_right[3]<=car_turn_left_right[3];
        car_turn_left_left[3]<=car_turn_left_left[3]; 
        end
        else if(car_turn_left_up[3]<90)
        begin
        car_turn_left_up[3]<=290;  
        car_turn_left_down[3]<=293;
        car_turn_left_right[3]<=217;
        car_turn_left_left[3]<=214;  
        end
        end
        end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        always @ (posedge vs or posedge rst)    
        begin
        if(rst==0)
        begin
        up_car_position_up[0]<=112;
        up_car_position_down[0]<=115;
        up_car_position_left[0]<=398+10;
        up_car_position_right[0]<=401+10; 
        car_turn_left_up[2]<=112;  
        car_turn_left_down[2]<=115;
        car_turn_left_right[2]<=445+3;
        car_turn_left_left[2]<=442+3;  
        end
        else if(up_car_position_down[0]>DOWN_BOUND)
        begin
        up_car_position_up[0]<=112;
        up_car_position_down[0]<=115;
        up_car_position_left[0]<=398+10;
        up_car_position_right[0]<=401+10;
        end  
        else if((btn==2'b11&&count_light==2'b11)||((btn==2'b00||btn==2'b01)&&(up_car_position_up[0]>black_line_up[1]||car_turn_left_up[2]>black_line_up[1])))
        begin
        if((btn==2'b11&&count_light==2'b11)||((btn==2'b00||btn==2'b01)&&(up_car_position_up[0]>black_line_up[1])))
        begin
        up_car_position_up[0]<=up_car_position_up[0]+1+speed[2];
        up_car_position_down[0]<=up_car_position_down[0]+1+speed[2];
        up_car_position_left[0]<=up_car_position_left[0];
        up_car_position_right[0]<=up_car_position_right[0]; 
        end
        if(car_turn_left_up[2]<190)
        begin
        car_turn_left_up[2]<=car_turn_left_up[2]+1;
        car_turn_left_down[2]<=car_turn_left_down[2]+1;
        car_turn_left_left[2]<=car_turn_left_left[2];
        car_turn_left_right[2]<=car_turn_left_right[2];   
        end
        else if(car_turn_left_up[2]>=190&&car_turn_left_left[2]<692)
        begin
        car_turn_left_up[2]<=car_turn_left_up[2]+1;
        car_turn_left_down[2]<=car_turn_left_down[2]+1;
        car_turn_left_left[2]<=car_turn_left_left[2]+2;
        car_turn_left_right[2]<=car_turn_left_right[2]+2;         
        end
        else if(car_turn_left_left[2]>=692&&car_turn_left_right[2]<RIGHT_BOUND)
        begin
        car_turn_left_up[2]<=car_turn_left_up[2];
        car_turn_left_down[2]<=car_turn_left_down[2];
        car_turn_left_left[2]<=car_turn_left_left[2]+1;
        car_turn_left_right[2]<=car_turn_left_right[2]+1;           
        
        end
        else if(car_turn_left_right[2]>=RIGHT_BOUND)
        begin
        car_turn_left_up[2]<=112;  
        car_turn_left_down[2]<=115;
        car_turn_left_right[2]<=445+3;
        car_turn_left_left[2]<=442+3;        
        end
        end
        end
        
        always@(count_light)
        begin
        case(count_light)
        2'b00:
        begin
        shuzi_up<=350;
        shuzi_down<=370;
        shuzi_left<=273;
        shuzi_right<=293;
        end
        2'b01:begin
        shuzi_up<=360;
        shuzi_down<=380;
        shuzi_left<=500;
        shuzi_right<=520;
        end        
        2'b10:
        begin
        shuzi_up<=225;
        shuzi_down<=245;
        shuzi_left<=640;
        shuzi_right<=660;
        end
        2'b11:
        begin
        shuzi_up<=170;
        shuzi_down<=190;
        shuzi_left<=380;
        shuzi_right<=400;
        end
        default:begin
        end
        endcase
        end        
        always@(count_55_0 or count_55_1)
        begin
        case(count_55_0)
        4'b0000:
        begin
        count_left[0]=20'b11111111111111111111;
        count_left[1]=20'b11111111111111111111;
        count_left[2]=20'b11111111111111111111;
        count_left[3]=20'b11111000000000011111;
        count_left[4]=20'b11111000000000011111;
        count_left[5]=20'b11111000000000011111;
        count_left[6]=20'b11111000000000011111;
        count_left[7]=20'b11111000000000011111;
        count_left[8]=20'b11111000000000011111;
        count_left[9]=20'b11111000000000011111;
        count_left[10]=20'b11111000000000011111;
        count_left[11]=20'b11111000000000011111;
        count_left[12]=20'b11111000000000011111;
        count_left[13]=20'b11111000000000011111;
        count_left[14]=20'b11111000000000011111;
        count_left[15]=20'b11111000000000011111;
        count_left[16]=20'b11111000000000011111;
        count_left[17]=20'b11111111111111111111;
        count_left[18]=20'b11111111111111111111;
        count_left[19]=20'b11111111111111111111;
        end        
        4'b0001:
        begin
        count_left[0]=20'b00000000001111100000;
        count_left[1]=20'b00000011111111100000;
        count_left[2]=20'b00011111111111100000;
        count_left[3]=20'b00000000001111100000;
        count_left[4]=20'b00000000001111100000;
        count_left[5]=20'b00000000001111100000;
        count_left[6]=20'b00000000001111100000;
        count_left[7]=20'b00000000001111100000;
        count_left[8]=20'b00000000001111100000;
        count_left[9]=20'b00000000001111100000;
        count_left[10]=20'b00000000001111100000 ;
        count_left[11]=20'b00000000001111100000 ;
        count_left[12]=20'b00000000001111100000 ;
        count_left[13]=20'b00000000001111100000 ;
        count_left[14]=20'b00000000001111100000 ;
        count_left[15]=20'b00000000001111100000 ;
        count_left[16]=20'b00000000001111100000 ;
        count_left[17]=20'b00000000001111100000 ;
        count_left[18]=20'b00000111111111111111 ;
        count_left[19]=20'b00000111111111111111 ;

        end
        4'b0010:
        begin
        count_left[0]=20'b11111111111111111111;
        count_left[1]=20'b11111111111111111111;
        count_left[2]=20'b11111111111111111111;
        count_left[3]=20'b00000000000000011111;
        count_left[4]=20'b00000000000000011111;
        count_left[5]=20'b00000000000000011111;
        count_left[6]=20'b00000000000000011111;
        count_left[7]=20'b00000000000000011111;
        count_left[8]=20'b00000000000000011111;
        count_left[9]=20'b11111111111111111111;
        count_left[10]=20'b11111111111111111111;
        count_left[11]=20'b11111000000000000000;
        count_left[12]=20'b11111000000000000000;
        count_left[13]=20'b11111000000000000000;
        count_left[14]=20'b11111000000000000000;
        count_left[15]=20'b11111000000000000000;
        count_left[16]=20'b11111000000000000000;
        count_left[17]=20'b11111111111111111111;
        count_left[18]=20'b11111111111111111111;
        count_left[19]=20'b11111111111111111111;

        end        
        4'b0011:
        begin
        count_left[0]=20'b11111111111111111111;
        count_left[1]=20'b11111111111111111111;
        count_left[2]=20'b11111111111111111111;
        count_left[3]=20'b00000000000000011111;
        count_left[4]=20'b00000000000000011111;
        count_left[5]=20'b00000000000000011111;
        count_left[6]=20'b00000000000000011111;
        count_left[7]=20'b00000000000000011111;
        count_left[8]=20'b00000000000000011111;
        count_left[9]=20'b11111111111111111111;
        count_left[10]=20'b11111111111111111111;
        count_left[11]=20'b00000000000000011111;
        count_left[12]=20'b00000000000000011111;
        count_left[13]=20'b00000000000000011111;
        count_left[14]=20'b00000000000000011111;
        count_left[15]=20'b00000000000000011111;
        count_left[16]=20'b00000000000000011111;
        count_left[17]=20'b11111111111111111111;
        count_left[18]=20'b11111111111111111111;
        count_left[19]=20'b11111111111111111111;
  
        end        
        4'b0100:
        begin
        count_left[0]=20'b11111000001111100000 ;
        count_left[1]=20'b11111000001111100000 ;
        count_left[2]=20'b11111000001111100000 ;
        count_left[3]=20'b11111000001111100000 ;
        count_left[4]=20'b11111000001111100000 ;
        count_left[5]=20'b11111000001111100000 ;
        count_left[6]=20'b11111000001111100000 ;
        count_left[7]=20'b11111000001111100000 ;
        count_left[8]=20'b11111000001111100000 ;
        count_left[9]=20'b11111111111111111111;
        count_left[10]=20'b11111111111111111111;
        count_left[11]=20'b00000000001111100000 ;
        count_left[12]=20'b00000000001111100000 ;
        count_left[13]=20'b00000000001111100000 ;
        count_left[14]=20'b00000000001111100000 ;
        count_left[15]=20'b00000000001111100000;
        count_left[16]=20'b00000000001111100000 ;
        count_left[17]=20'b00000000001111100000 ;
        count_left[18]=20'b00000000001111100000 ;
        count_left[19]=20'b00000000001111100000 ;
        end
        4'b0101:
        begin
        count_left[0]=20'b11111111111111111111;
        count_left[1]=20'b11111111111111111111;
        count_left[2]=20'b11111111111111111111;
        count_left[3]=20'b11111000000000000000 ;
        count_left[4]=20'b11111000000000000000 ;
        count_left[5]=20'b11111000000000000000 ;
        count_left[6]=20'b11111000000000000000 ;
        count_left[7]=20'b11111000000000000000 ;
        count_left[8]=20'b11111000000000000000 ;
        count_left[9]=20'b11111111111111111111;
        count_left[10]=20'b11111111111111111111;
        count_left[11]=20'b00000000000000011111;
        count_left[12]=20'b00000000000000011111;
        count_left[13]=20'b00000000000000011111;
        count_left[14]=20'b00000000000000011111;
        count_left[15]=20'b00000000000000011111;
        count_left[16]=20'b00000000000000011111;
        count_left[17]=20'b11111111111111111111;
        count_left[18]=20'b11111111111111111111;
        count_left[19]=20'b11111111111111111111;
        end        
        4'b0110:
        begin
        count_left[0]=20'b11111111111111111111;
        count_left[1]=20'b11111111111111111111;
        count_left[2]=20'b11111111111111111111;
        count_left[3]=20'b11111000000000000000 ;
        count_left[4]=20'b11111000000000000000 ;
        count_left[5]=20'b11111000000000000000 ;
        count_left[6]=20'b11111000000000000000 ;
        count_left[7]=20'b11111000000000000000 ;
        count_left[8]=20'b11111000000000000000 ;
        count_left[9]=20'b11111111111111111111;
        count_left[10]=20'b11111111111111111111;
        count_left[11]=20'b11111000000000011111;
        count_left[12]=20'b11111000000000011111;
        count_left[13]=20'b11111000000000011111;
        count_left[14]=20'b11111000000000011111;
        count_left[15]=20'b11111000000000011111;
        count_left[16]=20'b11111000000000011111;
        count_left[17]=20'b11111111111111111111;
        count_left[18]=20'b11111111111111111111;
        count_left[19]=20'b11111111111111111111;
        end        
        4'b0111:
        begin
        count_left[0]=20'b11111111111111111111;
        count_left[1]=20'b11111111111111111111;
        count_left[2]=20'b11111111111111111111;
        count_left[3]=20'b00000000000000011111;
        count_left[4]=20'b0000000000000011111;
        count_left[5]=20'b00000000000000011111;
        count_left[6]=20'b00000000000000011111;
        count_left[7]=20'b00000000000000011111;
        count_left[8]=20'b00000000000000011111;
        count_left[9]=20'b00000000000000011111;
        count_left[10]=20'b00000000000000011111;
        count_left[11]=20'b00000000000000011111;
        count_left[12]=20'b00000000000000011111;
        count_left[13]=20'b00000000000000011111;
        count_left[14]=20'b00000000000000011111;
        count_left[15]=20'b00000000000000011111;
        count_left[16]=20'b00000000000000011111;
        count_left[17]=20'b00000000000000011111;
        count_left[18]=20'b00000000000000011111;
        count_left[19]=20'b00000000000000011111;
        end        
        4'b1000:
        begin
        count_left[0]=20'b11111111111111111111;
        count_left[1]=20'b11111111111111111111;
        count_left[2]=20'b11111111111111111111;
        count_left[3]=20'b11111000000000011111;
        count_left[4]=20'b11111000000000011111;
        count_left[5]=20'b11111000000000011111;
        count_left[6]=20'b11111000000000011111;
        count_left[7]=20'b11111000000000011111;
        count_left[8]=20'b11111000000000011111;
        count_left[9]=20'b11111111111111111111;
        count_left[10]=20'b11111111111111111111;
        count_left[11]=20'b11111000000000011111;
        count_left[12]=20'b11111000000000011111;
        count_left[13]=20'b11111000000000011111;
        count_left[14]=20'b11111000000000011111;
        count_left[15]=20'b11111000000000011111;
        count_left[16]=20'b11111000000000011111;
        count_left[17]=20'b11111111111111111111;
        count_left[18]=20'b11111111111111111111;
        count_left[19]=20'b11111111111111111111;
 
        end        
        4'b1001:
        begin
        count_left[0]=20'b11111111111111111111;
        count_left[1]=20'b11111111111111111111;
        count_left[2]=20'b11111111111111111111;
        count_left[3]=20'b11111000000000011111;
        count_left[4]=20'b11111000000000011111;
        count_left[5]=20'b11111000000000011111;
        count_left[6]=20'b11111000000000011111;
        count_left[7]=20'b11111000000000011111;
        count_left[8]=20'b11111000000000011111;
        count_left[9]=20'b11111111111111111111;
        count_left[10]=20'b11111111111111111111;
        count_left[11]=20'b00000000000000011111;
        count_left[12]=20'b00000000000000011111;
        count_left[13]=20'b00000000000000011111;
        count_left[14]=20'b00000000000000011111;
        count_left[15]=20'b00000000000000011111;
        count_left[16]=20'b00000000000000011111;
        count_left[17]=20'b00000000000000011111;
        count_left[18]=20'b00000000000000011111;
        count_left[19]=20'b00000000000000011111;
        end        
        default:
        begin
        end                                
        endcase
        
        case(count_55_1)
        4'b0000:
        begin
        count_right[0]=20'b11111111111111111111;
        count_right[1]=20'b11111111111111111111;
        count_right[2]=20'b11111111111111111111;
        count_right[3]=20'b11111000000000011111;
        count_right[4]=20'b11111000000000011111;
        count_right[5]=20'b11111000000000011111;
        count_right[6]=20'b11111000000000011111;
        count_right[7]=20'b11111000000000011111;
        count_right[8]=20'b11111000000000011111;
        count_right[9]=20'b11111000000000011111;
        count_right[10]=20'b11111000000000011111;
        count_right[11]=20'b11111000000000011111;
        count_right[12]=20'b11111000000000011111;
        count_right[13]=20'b11111000000000011111;
        count_right[14]=20'b11111000000000011111;
        count_right[15]=20'b11111000000000011111;
        count_right[16]=20'b11111000000000011111;
        count_right[17]=20'b11111111111111111111;
        count_right[18]=20'b11111111111111111111;
        count_right[19]=20'b11111111111111111111;
        end        
        4'b0001:
        begin
        count_right[0]=20'b00000000001111100000;
        count_right[1]=20'b00000011111111100000;
        count_right[2]=20'b00011111111111100000;
        count_right[3]=20'b00000000001111100000;
        count_right[4]=20'b00000000001111100000;
        count_right[5]=20'b00000000001111100000;
        count_right[6]=20'b00000000001111100000;
        count_right[7]=20'b00000000001111100000;
        count_right[8]=20'b00000000001111100000;
        count_right[9]=20'b00000000001111100000;
        count_right[10]=20'b00000000001111100000 ;
        count_right[11]=20'b00000000001111100000 ;
        count_right[12]=20'b00000000001111100000 ;
        count_right[13]=20'b00000000001111100000 ;
        count_right[14]=20'b00000000001111100000 ;
        count_right[15]=20'b00000000001111100000 ;
        count_right[16]=20'b00000000001111100000 ;
        count_right[17]=20'b00000000001111100000 ;
        count_right[18]=20'b00000111111111111111 ;
        count_right[19]=20'b00000111111111111111 ;

        end
        4'b0010:
        begin
        count_right[0]=20'b11111111111111111111;
        count_right[1]=20'b11111111111111111111;
        count_right[2]=20'b11111111111111111111;
        count_right[3]=20'b00000000000000011111;
        count_right[4]=20'b00000000000000011111;
        count_right[5]=20'b00000000000000011111;
        count_right[6]=20'b00000000000000011111;
        count_right[7]=20'b00000000000000011111;
        count_right[8]=20'b00000000000000011111;
        count_right[9]=20'b11111111111111111111;
        count_right[10]=20'b11111111111111111111;
        count_right[11]=20'b11111000000000000000;
        count_right[12]=20'b11111000000000000000;
        count_right[13]=20'b11111000000000000000;
        count_right[14]=20'b11111000000000000000;
        count_right[15]=20'b11111000000000000000;
        count_right[16]=20'b11111000000000000000;
        count_right[17]=20'b11111111111111111111;
        count_right[18]=20'b11111111111111111111;
        count_right[19]=20'b11111111111111111111;

        end        
        4'b0011:
        begin
        count_right[0]=20'b11111111111111111111;
        count_right[1]=20'b11111111111111111111;
        count_right[2]=20'b11111111111111111111;
        count_right[3]=20'b00000000000000011111;
        count_right[4]=20'b00000000000000011111;
        count_right[5]=20'b00000000000000011111;
        count_right[6]=20'b00000000000000011111;
        count_right[7]=20'b00000000000000011111;
        count_right[8]=20'b00000000000000011111;
        count_right[9]=20'b11111111111111111111;
        count_right[10]=20'b11111111111111111111;
        count_right[11]=20'b00000000000000011111;
        count_right[12]=20'b00000000000000011111;
        count_right[13]=20'b00000000000000011111;
        count_right[14]=20'b00000000000000011111;
        count_right[15]=20'b00000000000000011111;
        count_right[16]=20'b00000000000000011111;
        count_right[17]=20'b11111111111111111111;
        count_right[18]=20'b11111111111111111111;
        count_right[19]=20'b11111111111111111111;
  
        end        
        4'b0100:
        begin
        count_right[0]=20'b11111000001111100000 ;
        count_right[1]=20'b11111000001111100000 ;
        count_right[2]=20'b11111000001111100000 ;
        count_right[3]=20'b11111000001111100000 ;
        count_right[4]=20'b11111000001111100000 ;
        count_right[5]=20'b11111000001111100000 ;
        count_right[6]=20'b11111000001111100000 ;
        count_right[7]=20'b11111000001111100000 ;
        count_right[8]=20'b11111000001111100000 ;
        count_right[9]=20'b11111111111111111111;
        count_right[10]=20'b11111111111111111111;
        count_right[11]=20'b00000000001111100000 ;
        count_right[12]=20'b00000000001111100000 ;
        count_right[13]=20'b00000000001111100000 ;
        count_right[14]=20'b00000000001111100000 ;
        count_right[15]=20'b00000000001111100000;
        count_right[16]=20'b00000000001111100000 ;
        count_right[17]=20'b00000000001111100000 ;
        count_right[18]=20'b00000000001111100000 ;
        count_right[19]=20'b00000000001111100000 ;
        end
        4'b0101:
        begin
        count_right[0]=20'b11111111111111111111;
        count_right[1]=20'b11111111111111111111;
        count_right[2]=20'b11111111111111111111;
        count_right[3]=20'b11111000000000000000 ;
        count_right[4]=20'b11111000000000000000 ;
        count_right[5]=20'b11111000000000000000 ;
        count_right[6]=20'b11111000000000000000 ;
        count_right[7]=20'b11111000000000000000 ;
        count_right[8]=20'b11111000000000000000 ;
        count_right[9]=20'b11111111111111111111;
        count_right[10]=20'b11111111111111111111;
        count_right[11]=20'b00000000000000011111;
        count_right[12]=20'b00000000000000011111;
        count_right[13]=20'b00000000000000011111;
        count_right[14]=20'b00000000000000011111;
        count_right[15]=20'b00000000000000011111;
        count_right[16]=20'b00000000000000011111;
        count_right[17]=20'b11111111111111111111;
        count_right[18]=20'b11111111111111111111;
        count_right[19]=20'b11111111111111111111;
        end        
        4'b0110:
        begin
        count_right[0]=20'b11111111111111111111;
        count_right[1]=20'b11111111111111111111;
        count_right[2]=20'b11111111111111111111;
        count_right[3]=20'b11111000000000000000 ;
        count_right[4]=20'b11111000000000000000 ;
        count_right[5]=20'b11111000000000000000 ;
        count_right[6]=20'b11111000000000000000 ;
        count_right[7]=20'b11111000000000000000 ;
        count_right[8]=20'b11111000000000000000 ;
        count_right[9]=20'b11111111111111111111;
        count_right[10]=20'b11111111111111111111;
        count_right[11]=20'b11111000000000011111;
        count_right[12]=20'b11111000000000011111;
        count_right[13]=20'b11111000000000011111;
        count_right[14]=20'b11111000000000011111;
        count_right[15]=20'b11111000000000011111;
        count_right[16]=20'b11111000000000011111;
        count_right[17]=20'b11111111111111111111;
        count_right[18]=20'b11111111111111111111;
        count_right[19]=20'b11111111111111111111;
        end        
        4'b0111:
        begin
        count_right[0]=20'b11111111111111111111;
        count_right[1]=20'b11111111111111111111;
        count_right[2]=20'b11111111111111111111;
        count_right[3]=20'b00000000000000011111;
        count_right[4]=20'b0000000000000011111;
        count_right[5]=20'b00000000000000011111;
        count_right[6]=20'b00000000000000011111;
        count_right[7]=20'b00000000000000011111;
        count_right[8]=20'b00000000000000011111;
        count_right[9]=20'b00000000000000011111;
        count_right[10]=20'b00000000000000011111;
        count_right[11]=20'b00000000000000011111;
        count_right[12]=20'b00000000000000011111;
        count_right[13]=20'b00000000000000011111;
        count_right[14]=20'b00000000000000011111;
        count_right[15]=20'b00000000000000011111;
        count_right[16]=20'b00000000000000011111;
        count_right[17]=20'b00000000000000011111;
        count_right[18]=20'b00000000000000011111;
        count_right[19]=20'b00000000000000011111;
        end        
        4'b1000:
        begin
        count_right[0]=20'b11111111111111111111;
        count_right[1]=20'b11111111111111111111;
        count_right[2]=20'b11111111111111111111;
        count_right[3]=20'b11111000000000011111;
        count_right[4]=20'b11111000000000011111;
        count_right[5]=20'b11111000000000011111;
        count_right[6]=20'b11111000000000011111;
        count_right[7]=20'b11111000000000011111;
        count_right[8]=20'b11111000000000011111;
        count_right[9]=20'b11111111111111111111;
        count_right[10]=20'b11111111111111111111;
        count_right[11]=20'b11111000000000011111;
        count_right[12]=20'b11111000000000011111;
        count_right[13]=20'b11111000000000011111;
        count_right[14]=20'b11111000000000011111;
        count_right[15]=20'b11111000000000011111;
        count_right[16]=20'b11111000000000011111;
        count_right[17]=20'b11111111111111111111;
        count_right[18]=20'b11111111111111111111;
        count_right[19]=20'b11111111111111111111;
 
        end        
        4'b1001:
        begin
        count_right[0]=20'b11111111111111111111;
        count_right[1]=20'b11111111111111111111;
        count_right[2]=20'b11111111111111111111;
        count_right[3]=20'b11111000000000011111;
        count_right[4]=20'b11111000000000011111;
        count_right[5]=20'b11111000000000011111;
        count_right[6]=20'b11111000000000011111;
        count_right[7]=20'b11111000000000011111;
        count_right[8]=20'b11111000000000011111;
        count_right[9]=20'b11111111111111111111;
        count_right[10]=20'b11111111111111111111;
        count_right[11]=20'b00000000000000011111;
        count_right[12]=20'b00000000000000011111;
        count_right[13]=20'b00000000000000011111;
        count_right[14]=20'b00000000000000011111;
        count_right[15]=20'b00000000000000011111;
        count_right[16]=20'b00000000000000011111;
        count_right[17]=20'b00000000000000011111;
        count_right[18]=20'b00000000000000011111;
        count_right[19]=20'b00000000000000011111;
        end        
        default:
        begin 
        end                                        
        endcase         
        end 
                             
endmodule    
