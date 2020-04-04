`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//
//  LAB SESSION DAY : THURSDAY A.M.
//
//  STUDENT A NAME: Lee Hao Yuan
//  STUDENT A MATRICULATION NUMBER: A0201511E 
//
//  STUDENT B NAME: Liu Yifeng
//  STUDENT B MATRICULATION NUMBER: A0206037N
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input CLK100MHZ,
    input [3:0] sw_hy,
    input [15:9] sw_yf,
    
    input PushCenter,
    
    input  J_MIC3_Pin3,   // Connect from this signal to Audio_Capture.v
    
    output J_MIC3_Pin1,   // Connect to this signal from Audio_Capture.v
    output J_MIC3_Pin4,
    output reg [15:0] led,
    output reg [3:0] an,
    output reg [6:0] seg,
    output reg dp,
    
    output  cs,
    output  sdin,
    output  sclk,
    output  d_cn,
    output  resn,
    output  vccen,
    output  pmoden
   
    );
    
    wire[11:0] mic_in;
    wire clk20k; 
    wire clk6p25m;
   
    wire C1;
    wire frame_begin;
    wire sending_pixels;
    wire sample_pixel;
    wire [12:0]pixel_index;
    wire reset, teststate;
    
    wire  cs1;
    wire  sdin1;
    wire  sclk1;
    wire  d_cn1;
    wire  resn1;
    wire  vccen1;
    wire  pmoden1;
    
    reg [15:0] oled_data;
    
    reg [11:0] max = 0; // amplitude of sound
    reg [4:0] state; // setting various state in stage 2
    reg [2:0] stage = 0; // for setting the lockscreen stage
    reg [15:0] countf = 0; // for setting the sampling frequency
    reg[17:0] COUNT = 0; // 2.6ms, for all 4 an to display simultaneously (used in stage 2)
    reg[17:0] COUNT1 = 0; // 2.6ms, for all 4 an to display simultaneously (used in lockscreen stage)
    reg[23:0] COUNT2 = 0; // 0.67s, to cycle through the 4 an
    reg[23:0] COUNT3 = 0;
    reg[17:0] COUNT4 = 0;
    reg[1:0] count = 0; // for all 4 anode to display different things simultaneosuly (used in stage 2)
    reg[2:0] count1 = 0; // for all 4 anode to display different things simultaneosuly (used in lockscreen stage)
    reg[2:0] count4 = 0;
    reg[3:0] cycle = 0; // for cycling through the 4 an
    reg[3:0] cycle1 = 0;
    
    
    clock_switch(CLK100MHZ, clk6p25m);
    
    clock_divider dev1(CLK100MHZ, clk20k);
    
    colour_display dev4(.clk6p25m_colour(clk6p25m),.sw(sw_yf),.state1(state),.stage1(stage),.push_game(PushCenter),.cs_colour(cs),.sdin_colour(sdin),.sclk_colour(sclk),.d_cn_colour(d_cn),.resn_colour(resn),.vccen_colour(vccen),.pmoden_colour(pmoden));
        
    Audio_Capture dev2(CLK100MHZ, clk20k, J_MIC3_Pin3, J_MIC3_Pin1, J_MIC3_Pin4 , mic_in);
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    always @(posedge clk20k) begin
        
        if(sw_hy[1] == 1 && sw_hy[2] == 0) begin // switch 1 is on
            countf <= (countf == 1000) ? 0 : countf + 1; // fast sampling frequency ~ 20Hz (extra sensitive mic)
        end
        
        else if(sw_hy[1] == 1 && sw_hy[2] == 1) begin // both switch 1 & 2 are on
            countf <= (countf == 10000) ? 0 : countf + 1; // slow sampling frequency ~ 2Hz (not very responsive mic)
        end
        
        else begin // switch 1 and 2 off
            countf <= (countf == 2000) ? 0 : countf + 1; // default sampling frequency ~ 10Hz
        end
        
        if(countf == 0) begin
            max <= 0;
        end
        
        else if(countf != 0) begin
        
            if(mic_in > max) begin
                max <= mic_in;
            end
            
            else if(mic_in < max) begin
                max <= max;
            end
        end        
        
        if(sw_hy[0] == 0 && stage == 2) begin // basic task
            led[11:0] = mic_in;
            led[15:12] = 0;
            state = 0;
        end
        
        else if(countf == 0 && sw_hy[0] == 1 && stage == 2) begin // volume indicator task
 
            if(max < 2000) begin // very low volume
                led <= 16'b0000000000000000;
            end
            
            else if(max > 2000 && max < 2123) begin // led 0
                led <= 16'b0000000000000001;
                state <= 1;
            end
            
            else if(max > 2123 && max < 2246) begin // led 1
                led <= 16'b0000000000000011;
                state <= 2;
            end
            
            else if(max > 2246 && max < 2369) begin // led 2
                led <= 16'b0000000000000111;
                state <= 3;
            end
                        
            else if(max > 2369 && max < 2492) begin // led 3
                led <= 16'b0000000000001111;
                state <= 4;
            end
            
            else if(max > 2492 && max < 2615) begin // led 4
                led <= 16'b0000000000011111;
                state <= 5;
            end
            
            else if(max > 2615 && max < 2738) begin // led 5
                led <= 16'b0000000000111111;
                state <= 6;
            end
            
            else if(max > 2738 && max < 2861) begin // led 6
                led <= 16'b0000000001111111;
                state <= 7;
            end
            
            else if(max > 2861 && max < 2984) begin // led 7
                led <= 16'b0000000011111111; 
                state <= 8;
            end
            
            else if(max > 2984 && max < 3107) begin // led 8
                led <= 16'b0000000111111111;
                state <= 9;
            end
            
            else if(max > 3107 && max < 3230) begin // led 9
                led <= 16'b0000001111111111;
                state <= 10;
            end
            
            else if(max > 3230 && max < 3353) begin // led 10
                led <= 16'b0000011111111111;
                state <= 11;
            end
            
            else if(max > 3353 && max < 3476) begin // led 11
                led <= 16'b0000111111111111;
                state <= 12;
            end
            
            else if(max > 3476 && max < 3599) begin // led 12
                led <= 16'b0001111111111111;
                state <= 13;
            end
            
            else if(max > 3599 && max < 3722) begin // led 13
                led <= 16'b0011111111111111;
                state <= 14;
            end
            
            else if(max > 3722 && max < 3845) begin // led 14
                led <= 16'b0111111111111111;
                state <= 15;
            end
                        
            else if(max > 3845) begin // led 15
                led <= 16'b1111111111111111;
                state <= 16;
            end
        
        end
     
    end // end of 1st always    
                                                                              
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    always @ (posedge CLK100MHZ) begin //  for the 7 segment display
        
        COUNT <= COUNT + 1;
        COUNT1 <= COUNT1 + 1; 
        COUNT2 <= COUNT2 + 1;
        COUNT3 <= COUNT3 + 1;
        COUNT4 <= COUNT4 + 1;
        
        if(COUNT == 0 && stage == 2) begin
            count <= count +1;      
            stage = 2;                  
        end
        
        case(count)
            0:
            begin
            dp = 1;
            an = 4'b1110; // display on an0
                if(state == 1 || state == 11) begin // 0 
                    seg = 7'b1000000;
                end
                
                else if(state == 2 || state == 12) begin // 1 
                    seg = 7'b1111001;
                end  
                
                else if(state == 3 || state == 13) begin // 2
                    seg = 7'b0100100;
                end
                
                else if(state == 4 || state == 14) begin // 3
                    seg = 7'b0110000;
                end
                
                else if(state == 5 || state == 15) begin // 4
                    seg = 7'b0011001;
                end  
                
                else if(state == 6 || state == 16) begin // 5
                    seg = 7'b0010010;
                end
                
                else if(state == 7) begin // 6
                    seg = 7'b0000010;
                end
                
                else if(state == 8) begin // 7
                    seg = 7'b1111000;
                end
                
                else if(state == 9) begin // 8
                    seg = 7'b0000000;
                end
                
                else if(state == 10) begin // 9
                    seg = 7'b0010000;
                end
                
                else if(state == 0) begin // blank display
                    seg = 7'b1111111;
                end
                
            end
            
            1:
            begin
            dp = 1;
            an = 4'b1101; // display on an1
                if(state == 1 || state == 2 || state == 3 || state == 4 || state == 5 || state == 6 || state == 7 || state == 8 || state == 9 || state == 10 || state == 0) begin // blank display
                    seg = 7'b1111111; 
                end
                
                if(state == 11 || state == 12 || state == 13 || state == 14 || state == 15 || state == 16 ) begin // 1
                    seg = 7'b1111001; 
                end
                
            end
            
                 
        endcase    
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////// for lockscreen unlock (stage 0 & 1)  
                        
        if(COUNT1 == 0 && stage == 0) begin
            count1 <= count1 + 1;
        end
        
        if(COUNT2 == 0 && stage == 0) begin
            cycle <= cycle + 1;
        end    
        
        if(COUNT4 == 0 && stage == 1) begin
            count4 <= count4 + 1;
        end
        
        if(COUNT3 == 0 && stage == 1) begin
            cycle1 <= cycle1 + 1;
        end       
               
        /////////////////////////////////////////////////////////////////////////// stage 0          
               
        if (stage == 0) begin // displays "LOCKED"
            if(cycle == 1) begin
                if (stage == 0 && count1 == 1) begin // L
                    an = 4'b1110;
                    seg = 7'b1000111;    
                end
                
                if(max > 3845) begin
                    stage = 1;
                end 
            end
            
            else if(cycle == 2) begin
                if (stage == 0 && count1 == 1) begin // L
                    an = 4'b1101;
                    seg = 7'b1000111;    
                end   
                
                else if (stage == 0 && count1 == 2) begin // O
                    an = 4'b1110;
                    seg = 7'b1000000;
                end                       
                
                if(max > 3845) begin
                    stage = 1;
                end 
            end
            
            else if(cycle == 3) begin
                if (stage == 0 && count1 == 1) begin // L
                    an = 4'b1011;
                    seg = 7'b1000111;    
                end   
                
                else if (stage == 0 && count1 == 2) begin // O
                    an = 4'b1101;
                    seg = 7'b1000000;
                end   
                    
                else if (stage == 0 && count1 == 3) begin // C
                    an = 4'b1110;
                    seg = 7'b1000110;
                end
                
                if(max > 3845) begin
                    stage = 1;
                end 
            end
            
            else if(cycle == 4) begin
                if (stage == 0 && count1 == 1) begin // L
                    an = 4'b0111;
                    seg = 7'b1000111;    
                end   
                
                else if (stage == 0 && count1 == 2) begin // O
                    an = 4'b1011;
                    seg = 7'b1000000;
                end   
                    
                else if (stage == 0 && count1 == 3) begin // C
                    an = 4'b1101;
                    seg = 7'b1000110;
                end
                    
                else if (stage == 0 && count1 == 4) begin // K
                    an = 4'b1110;
                    seg = 7'b0001001;
                end
                
                if(max > 3845) begin
                    stage = 1;
                end 
            end
                
            else if(cycle == 5) begin    
                if (stage == 0 && count1 == 1) begin // O
                    an = 4'b0111;
                    seg = 7'b1000000;
                end   
                    
                else if (stage == 0 && count1 == 2) begin // C
                    an = 4'b1011;
                    seg = 7'b1000110;
                end
                    
                else if (stage == 0 && count1 == 3) begin // K
                    an = 4'b1101;
                    seg = 7'b0001001;
                end
                
                else if (stage == 0 && count1 == 4) begin // E
                    an = 4'b1110;
                    seg = 7'b0000110;
                end
                
                if(max > 3845) begin
                    stage = 1;
                end 
            end
            
            else if(cycle == 6) begin        
                if (stage == 0 && count1 == 1) begin // C
                    an = 4'b0111;
                    seg = 7'b1000110;
                end
                    
                else if (stage == 0 && count1 == 2) begin // K
                    an = 4'b1011;
                    seg = 7'b0001001;
                end
                
                else if (stage == 0 && count1 == 3) begin // E
                    an = 4'b1101;
                    seg = 7'b0000110;
                end
                
                else if (stage == 0 && count1 == 4) begin // D
                    an = 4'b1110;
                    seg = 7'b0100001;
                end
                
                if(max > 3845) begin
                    stage = 1;
                end 
            end
            
            else if(cycle == 7) begin        
                if (stage == 0 && count1 == 1) begin // K
                    an = 4'b0111;
                    seg = 7'b0001001;
                end
                
                else if (stage == 0 && count1 == 2) begin // E
                    an = 4'b1011;
                    seg = 7'b0000110;
                end
                
                else if (stage == 0 && count1 == 3) begin // D
                    an = 4'b1101;
                    seg = 7'b0100001;
                end
                
                if(max > 3845) begin
                    stage = 1;
                end 
            end
                        
            else if(cycle == 8) begin        
                if (stage == 0 && count1 == 1) begin // E
                    an = 4'b0111;
                    seg = 7'b0000110;
                end
                
                else if (stage == 0 && count1 == 2) begin // D
                    an = 4'b1011;
                    seg = 7'b0100001;
                end
                
                if(max > 3845) begin
                    stage = 1;
                end 
            end
            
            else if(cycle == 9) begin        
                if (stage == 0 && count1 == 1) begin // D
                    an = 4'b0111;
                    seg = 7'b0100001;
                end
                
                if(max > 3845) begin
                    stage = 1;
                end 
            end          
            
            else if(cycle == 10) begin        
                an = 4'b1111;
                
                if(max > 3845) begin
                    stage = 1;
                end 
            end
                        
            else begin
                cycle = 1;
            end
            
        end
        
        //////////////////////////////////////////////////////////////////////////////////// stage 1
        
        if(stage == 1) begin// displays "UNLOCKED"
            if(cycle1 == 1)begin
                if (stage == 1 && count4 == 1) begin // U
                    an = 4'b1110;
                    seg = 7'b1000001;    
                end
            end
            
            if(cycle1 == 2)begin
                if (stage == 1 && count4 == 1) begin // U
                    an = 4'b1101;
                    seg = 7'b1000001;    
                end
                
                else if (stage == 1 && count4 == 2) begin // N
                    an = 4'b1110;
                    seg = 7'b0101011;    
                end       
            end
            
            else if(cycle1 == 3)begin
                if (stage == 1 && count4 == 1) begin // U
                    an = 4'b1011;
                    seg = 7'b1000001;    
                end
                
                else if (stage == 1 && count4 == 2) begin // N
                    an = 4'b1101;
                    seg = 7'b0101011;    
                end
                                
                else if (stage == 1 && count4 == 3) begin // L
                    an = 4'b1110;
                    seg = 7'b1000111;    
                end          
            end
            
            else if(cycle1 == 4)begin
                if (stage == 1 && count4 == 1) begin // U
                    an = 4'b0111;
                    seg = 7'b1000001;    
                end
                
                else if (stage == 1 && count4 == 2) begin // N
                    an = 4'b1011;
                    seg = 7'b0101011;    
                end
                                
                else if (stage == 1 && count4 == 3) begin // L
                    an = 4'b1101;
                    seg = 7'b1000111;    
                end   
                
                else if (stage == 1 && count4 == 4) begin // O
                    an = 4'b1110;
                    seg = 7'b1000000;
                end             
            end
            
            else if(cycle1 == 5)begin
                if (stage == 1 && count4 == 1) begin // N
                    an = 4'b0111;
                    seg = 7'b0101011;    
                end
                                
                else if (stage == 1 && count4 == 2) begin // L
                    an = 4'b1011;
                    seg = 7'b1000111;    
                end   
                
                else if (stage == 1 && count4 == 3) begin // O
                    an = 4'b1101;
                    seg = 7'b1000000;
                end  
                
                else if (stage == 1 && count4 == 4) begin // C
                    an = 4'b1110;
                    seg = 7'b1000110;
                end     
            end
            
            else if(cycle1 == 6)begin
                if (stage == 1 && count4 == 1) begin // L
                    an = 4'b0111;
                    seg = 7'b1000111;    
                end   
                
                else if (stage == 1 && count4 == 2) begin // O
                    an = 4'b1011;
                    seg = 7'b1000000;
                end   
                    
                else if (stage == 1 && count4 == 3) begin // C
                    an = 4'b1101;
                    seg = 7'b1000110;
                end
                    
                else if (stage == 1 && count4 == 4) begin // K
                    an = 4'b1110;
                    seg = 7'b0001001;
                end             
            end
                
            else if(cycle1 == 7)begin    
                if (stage == 1 && count4 == 1) begin // O
                    an = 4'b0111;
                    seg = 7'b1000000;
                end   
                    
                else if (stage == 1 && count4 == 2) begin // C
                    an = 4'b1011;
                    seg = 7'b1000110;
                end
                    
                else if (stage == 1 && count4 == 3) begin // K
                    an = 4'b1101;
                    seg = 7'b0001001;
                end
                
                else if (stage == 1 && count4 == 4) begin // E
                    an = 4'b1110;
                    seg = 7'b0000110;
                end                
            end
            
            else if(cycle1 == 8)begin        
                if (stage == 1 && count4 == 1) begin // C
                    an = 4'b0111;
                    seg = 7'b1000110;
                end
                    
                else if (stage == 1 && count4 == 2) begin // K
                    an = 4'b1011;
                    seg = 7'b0001001;
                end
                
                else if (stage == 1 && count4 == 3) begin // E
                    an = 4'b1101;
                    seg = 7'b0000110;
                end
                
                else if (stage == 1 && count4 == 4) begin // D
                    an = 4'b1110;
                    seg = 7'b0100001;
                end                
            end
            
            else if(cycle1 == 9)begin        
                if (stage == 1 && count4 == 1) begin // K
                    an = 4'b0111;
                    seg = 7'b0001001;
                end
                
                else if (stage == 1 && count4 == 2) begin // E
                    an = 4'b1011;
                    seg = 7'b0000110;
                end
                
                else if (stage == 1 && count4 == 3) begin // D
                    an = 4'b1101;
                    seg = 7'b0100001;
                end                
            end
            
            else if(cycle1 == 10)begin        
                if (stage == 1 && count4 == 1) begin // E
                    an = 4'b0111;
                    seg = 7'b0000110;
                end
                
                else if (stage == 1 && count4 == 2) begin // D
                    an = 4'b1011;
                    seg = 7'b0100001;
                end                
            end
            
            else if(cycle1 == 11)begin        
                if (stage == 1 && count4 == 1) begin // D
                    an = 4'b0111;
                    seg = 7'b0100001;
                end                
            end
            
            else if(cycle1 == 13)begin
                stage = 2;
            end
            
        end
        
    end // end of 2nd always   
         
    
endmodule