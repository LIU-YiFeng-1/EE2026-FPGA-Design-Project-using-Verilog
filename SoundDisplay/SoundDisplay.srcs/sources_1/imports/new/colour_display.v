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


module colour_display (
    input clk6p25m_colour,
    input [15:9] sw,
    input [4:0] state1, //input data from the mic
    input [2:0] stage1,
    input push_game,
    output  cs_colour,
    output  sdin_colour,
    output  sclk_colour,
    output  d_cn_colour,
    output  resn_colour,
    output  vccen_colour,
    output  pmoden_colour
    
    );
    
    wire [4:0] state_colour; //wire input data from the mic
    wire [1:0] border;
    wire C1_RGB;
    wire C1_PURPLE;
    wire C1_RED;
    wire frame_begin_colour;
    wire sending_pixels_colour;
    wire sample_pixel_colour;
    wire [12:0] pixel_index_colour;
    reg [15:0] oled_data_colour = 16'b0;
    wire theme_RGB, theme_PURPLE, theme_RED;
    wire teststate_colour;
    wire [6:0] x_code_colour;
    wire [5:0] y_code_colour;
    wire [11:0] x_code_circle;
    wire [11:0] y_code_circle;
    wire reset_colour;
    
    reg [2:0] stage = 0; //to select different colour themes.
    reg [4:0] state_colour_temp;
    
    //for game mode
    reg [1:0] game_mode=0;
    reg [5:0]y_up0=6'd4;
    reg [5:0]y_up1=6'd8;
    reg [5:0]y_up2=6'd12;
    reg [5:0]y_up3=6'd16;
    reg [5:0]y_up4=6'd20;
    reg [5:0]y_up5=6'd24;
    reg [5:0]y_up6=6'd27;
    reg [5:0]y_up7=6'd30;
    reg [5:0]y_up8=6'd33;
    reg [5:0]y_up9=6'd36;
    reg [5:0]y_up10=6'd39;
    reg [5:0]y_up11=6'd41;
    reg [5:0]y_up12=6'd44;
    reg [6:0]y_reference = 7'b0;
    reg [6:0]x_reference = 7'b0;
    reg [2:0] pipe =3'b0;
    reg [1:0] death =2'b0;
    reg [6:0] pipe_bottom = 0;
    reg [6:0] pipe_top =0;
    reg [6:0] bird_bottom = 7'd62;
    reg [6:0] bird_top = 7'd49;

    
    parameter white = 16'b11111_111111_11111;
    parameter black = 16'b0;
    parameter red = 16'b11111_000000_00000;
    parameter colour15 = 16'hF9E0;
    parameter colour14 = 16'hF9E0;
    parameter colour13 = 16'hFA80;
    parameter colour12 = 16'hFB40;
    parameter colour11 = 16'hFC00;
    parameter colour10 = 16'hFCA0;
    parameter colour9 = 16'hFD60;
    parameter colour8 = 16'hFE20;
    parameter colour7 = 16'hFEC0;
    parameter colour6 = 16'hFF80;
    parameter colour5 = 16'hEFE0;
    parameter colour4 = 16'hCFE0;
    parameter colour3 = 16'hB7E0;
    parameter colour2 = 16'h9FE0;
    parameter colour1 = 16'h6FE0;
    parameter colour0 = 16'h6FE0;
    parameter grey = 16'hD679;
    parameter brown = 16'h82AA;
    parameter yellow = 16'hFF80;
    parameter bright_yellow = 16'hF7AE;
    parameter light_green = 16'h8FFF; //white tale
    parameter green1 = 16'h3719; //darker tale
    parameter green2 = 16'h1E35;//darkest tale
    parameter dark_green = 16'h3E58; //???
    parameter dark_blue = 16'h2B1D;
    parameter black_blue = 16'h0154;
    parameter dark_red = 16'hB904;
    parameter purple = 16'hC9B0;
    parameter skin_lock = 16'hFDB6;
    parameter orange = 16'hFCC1;
    parameter dark_yellow =16'hFE87;
    parameter white_yellow = 16'hFFF4;
    parameter skin_colour = 16'hFDB6;
    parameter green = 16'b00000_111111_00000;

    
    pixel_index_system(pixel_index_colour, x_code_colour, y_code_colour, x_code_circle, y_code_circle); //getting the x and y coordinates of the pixel index system
    
    select_border(clk6p25m_colour, sw[15:14], border);
    
    Oled_Display(clk6p25m_colour, reset_colour, frame_begin_colour, sending_pixels_colour,
      sample_pixel_colour, pixel_index_colour, oled_data_colour, cs_colour, sdin_colour, sclk_colour, d_cn_colour, resn_colour, vccen_colour,
      pmoden_colour,teststate_colour);
      
    assign state_colour = sw[13] ? state_colour_temp : state1; // switch 13 is used to take a "screenshot" of OLED
    
    
    always @(posedge clk6p25m_colour)begin
    
        if(stage1==0)begin // display locked screen stage
            // lock display
            if((x_code_colour>32 && x_code_colour<62) && (y_code_colour>= 13 && y_code_colour<= 30)) begin
                oled_data_colour = yellow; 
            end
            
            else if((x_code_colour>36 && x_code_colour<42) && (y_code_colour>= 8 && y_code_colour<= 12)) begin
                oled_data_colour = red; 
            end
            
            else if((x_code_colour>52 && x_code_colour<58) && (y_code_colour>= 8 && y_code_colour<= 12)) begin
                oled_data_colour = red; 
            end
            
            else if((x_code_colour>36 && x_code_colour<46) && (y_code_colour>= 5 && y_code_colour<= 7)) begin
                oled_data_colour = red;
            end
            
            else if((x_code_colour>50 && x_code_colour<58) && (y_code_colour>= 5 && y_code_colour<= 7)) begin
                oled_data_colour =red;
            end
            
            else if((x_code_colour>40 && x_code_colour<50) && (y_code_colour>= 2 && y_code_colour<= 4)) begin
                oled_data_colour = red; 
            end
            
            else if((x_code_colour>44 && x_code_colour<56) && (y_code_colour>= 2 && y_code_colour<= 4)) begin
                oled_data_colour = red;
            end
            
            else if((x_code_colour>44 && x_code_colour<50) && (y_code_colour == 1))begin
                oled_data_colour = red; 
            end
            
            // mario display  height start with 35th pixels
            else if((x_code_colour>42 && x_code_colour<50) && (y_code_colour==35))begin
                oled_data_colour = brown; end     
            else if((x_code_colour>=42 && x_code_colour<=43) && (y_code_colour==36))begin
                oled_data_colour = brown; end                   
            else if((x_code_colour==51) && (y_code_colour>=37 && y_code_colour <=39))begin
                oled_data_colour = brown; end                     
            else if((x_code_colour==41) && (y_code_colour>=37 && y_code_colour <=38))begin
                oled_data_colour = brown; end                     
            else if((x_code_colour==40) && (y_code_colour>=38 && y_code_colour <=40))begin
                oled_data_colour = brown; end                 
            else if((x_code_colour==39) && (y_code_colour>=40 && y_code_colour <=41))begin
                oled_data_colour = brown; end                    
            else if((x_code_colour>=38 && x_code_colour<=40) && (y_code_colour==42))begin
                oled_data_colour = brown; end      
                    
            else if((x_code_colour>=44 && x_code_colour<=48) && (y_code_colour==36))begin
                oled_data_colour = red; end  
            else if((x_code_colour>=42 && x_code_colour<=50) && (y_code_colour==37))begin
                oled_data_colour = red; end                             
            else if((x_code_colour>=42 && x_code_colour<=50) && (y_code_colour==38))begin
                oled_data_colour = red; end                             
            else if((x_code_colour>=41 && x_code_colour<=45) && (y_code_colour==39))begin
                oled_data_colour = red; end                                
            else if((x_code_colour>=49 && x_code_colour<=50) && (y_code_colour==39))begin
                oled_data_colour = red; end                              
                            
            else if((x_code_colour>=44 && x_code_colour<=51) && (y_code_colour>=41 && y_code_colour<=42))begin
                oled_data_colour = black; end                             
            else if((x_code_colour>=48 && x_code_colour<=49) && (y_code_colour==43))begin
                oled_data_colour = black; end                              
            else if((x_code_colour>=42 && x_code_colour<=43) && (y_code_colour>=42 && y_code_colour<=46))begin
                oled_data_colour = black; end                              
            else if((x_code_colour>=42 && x_code_colour<=48) && (y_code_colour==48))begin
                oled_data_colour = black; end                             
            else if((x_code_colour>=44 && x_code_colour<=49) && (y_code_colour==49))begin
                oled_data_colour = black; end  
            else if((x_code_colour==45) && (y_code_colour>=44 && y_code_colour<=45))begin
                oled_data_colour = black; end                                          
            else if((x_code_colour==47) && (y_code_colour>=44 && y_code_colour<=45))begin
                oled_data_colour = black; end                                         
            else if((x_code_colour==44) && (y_code_colour==55))begin
                oled_data_colour = black; end                                                
            else if((x_code_colour==47) && (y_code_colour>=52 && y_code_colour<=55))begin
                oled_data_colour = black; end 
            else if((x_code_colour==50) && (y_code_colour>=54 && y_code_colour<=55))begin
                oled_data_colour = black; end
            else if((x_code_colour==51) && (y_code_colour==56))begin
                oled_data_colour = black; end
            else if((x_code_colour==50) && (y_code_colour==52))begin
                oled_data_colour = black; end                     

            else if((x_code_colour==40) && (y_code_colour>=56 && y_code_colour<=59))begin
                oled_data_colour = dark_blue; end
            else if((x_code_colour==41) && (y_code_colour>=57 && y_code_colour<=59))begin
                oled_data_colour = dark_blue; end
            else if((x_code_colour==42) && (y_code_colour>=59 && y_code_colour<=61))begin
                oled_data_colour = dark_blue; end
            else if((x_code_colour==43) && (y_code_colour>=60 && y_code_colour<=62))begin
                oled_data_colour = dark_blue; end
            else if((x_code_colour==51) && (y_code_colour>=57 && y_code_colour<=61))begin
                oled_data_colour = dark_blue; end
            else if((x_code_colour==52) && (y_code_colour>=54 && y_code_colour<=58))begin
                oled_data_colour = dark_blue; end
            else if((x_code_colour==53) && (y_code_colour>=54 && y_code_colour<=55))begin
                oled_data_colour = dark_blue; end
            else if((x_code_colour>=44 && x_code_colour<=45) && (y_code_colour==61))begin
                oled_data_colour = dark_blue; end
            else if((x_code_colour>=44 && x_code_colour<=47) && (y_code_colour==62))begin
                oled_data_colour = dark_blue; end
            else if((x_code_colour==54) && (y_code_colour==55))begin
                oled_data_colour = dark_blue; end

            else if((x_code_colour==48) && (y_code_colour==53))begin
                oled_data_colour = black_blue; end
            else if((x_code_colour==50) && (y_code_colour==53))begin
                oled_data_colour = black_blue; end
            else if((x_code_colour==45) && (y_code_colour==53))begin
                oled_data_colour = black_blue; end
            else if((x_code_colour==51) && (y_code_colour>=54 && y_code_colour<=55))begin
                oled_data_colour = black_blue; end
            else if((x_code_colour>=50 && x_code_colour<=51) && (y_code_colour>=50 && y_code_colour<=51))begin
                oled_data_colour = black_blue; end
            else if((x_code_colour>=51 && x_code_colour<=52) && (y_code_colour>=52 && y_code_colour<=53))begin
                oled_data_colour = black_blue; end

            else if((x_code_colour>=41 && x_code_colour<=42) && (y_code_colour==56))begin
                oled_data_colour = dark_green; end
            else if((x_code_colour>=43 && x_code_colour<=44) && (y_code_colour==59))begin
                oled_data_colour = dark_green; end
            else if((x_code_colour>=44 && x_code_colour<=46) && (y_code_colour==60))begin
                oled_data_colour = dark_green; end
            else if((x_code_colour>=46 && x_code_colour<=47) && (y_code_colour==61))begin
                oled_data_colour = dark_green; end
            else if((x_code_colour==42) && (y_code_colour>=57 && y_code_colour<=58))begin
                oled_data_colour = dark_green; end

            else if((x_code_colour==47) && (y_code_colour>=56 && y_code_colour<=60))begin
                oled_data_colour = light_green; end
            else if((x_code_colour==50) && (y_code_colour>=56 && y_code_colour<=61))begin
                oled_data_colour = light_green; end  
            else if((x_code_colour>=43 && x_code_colour<=44) && (y_code_colour>=56 && y_code_colour<=58))begin
                oled_data_colour = light_green; end                     
            else if((x_code_colour>=45 && x_code_colour<=46) && (y_code_colour>=58 && y_code_colour<=59))begin
                oled_data_colour = light_green; end                     
            else if((x_code_colour>=48 && x_code_colour<=49) && (y_code_colour>=58 && y_code_colour<=61))begin
                oled_data_colour = light_green; end                     
                    
            else if((x_code_colour>=45 && x_code_colour<=46) && (y_code_colour==55))begin
                oled_data_colour = green1; end                     
            else if((x_code_colour>=48 && x_code_colour<=49) && (y_code_colour==55))begin
                oled_data_colour = green1; end                     
                    
            else if((x_code_colour>=45 && x_code_colour<=46) && (y_code_colour==54))begin
                oled_data_colour = green2; end                     
            else if((x_code_colour>=48 && x_code_colour<=49) && (y_code_colour==54))begin
                oled_data_colour = green2; end                     

            else if((x_code_colour>=49 && x_code_colour<=51) && (y_code_colour==48))begin
                oled_data_colour = dark_red; end
            else if((x_code_colour>=50 && x_code_colour<=51) && (y_code_colour==49))begin
                oled_data_colour = dark_red; end

            else if((x_code_colour>=45 && x_code_colour<=46) && (y_code_colour==52))begin
                oled_data_colour = purple; end
            else if((x_code_colour>=48 && x_code_colour<=49) && (y_code_colour==52))begin
                oled_data_colour = purple; end
            else if((x_code_colour==46) && (y_code_colour==53))begin
                oled_data_colour = purple; end
            else if((x_code_colour==49) && (y_code_colour==53))begin
                oled_data_colour = purple; end

            else if((x_code_colour>=44 && x_code_colour<=48) && (y_code_colour==46))begin
                oled_data_colour = skin_lock; end
            else if((x_code_colour>=42 && x_code_colour<=48) && (y_code_colour==47))begin
                oled_data_colour = skin_lock; end
            else if((x_code_colour>=41 && x_code_colour<=43) && (y_code_colour==49))begin
                oled_data_colour = skin_lock; end
            else if((x_code_colour>=43 && x_code_colour<=48) && (y_code_colour==50))begin
                oled_data_colour = skin_lock; end
            else if((x_code_colour>=49 && x_code_colour<=50) && (y_code_colour>=44 && y_code_colour<=47))begin
                oled_data_colour = skin_lock; end
            else if((x_code_colour>=40 && x_code_colour<=41) && (y_code_colour>=47 && y_code_colour<=48))begin
                oled_data_colour = skin_lock; end                     
            else if((x_code_colour==46) && (y_code_colour>=43 && y_code_colour<=45))begin
                oled_data_colour = skin_lock; end


            else if((x_code_colour==41) && (y_code_colour>=40 && y_code_colour<=46))begin
                oled_data_colour = orange; end
            else if((x_code_colour>=42 && x_code_colour<=43) && (y_code_colour>=40 && y_code_colour<=41))begin
                oled_data_colour = orange; end
            else if((x_code_colour>=50 && x_code_colour<=51) && (y_code_colour==40))begin
                oled_data_colour = orange; end                     
                    
            else if((x_code_colour>=46 && x_code_colour<=47) && (y_code_colour>=39 && y_code_colour<=40))begin
                oled_data_colour = yellow; end
            else if((x_code_colour==45) && (y_code_colour==40))begin
                oled_data_colour = yellow; end


            else if((x_code_colour>=53 && x_code_colour<=54) && (y_code_colour>=36 && y_code_colour<=37))begin
                oled_data_colour = brown; end
            else if((x_code_colour==56) && (y_code_colour>=36 && y_code_colour<=39))begin
                oled_data_colour = brown; end
            else if((x_code_colour==55) && (y_code_colour>=38 && y_code_colour<=39))begin
                oled_data_colour = brown; end
            else if((x_code_colour>=53 && x_code_colour<=54) && (y_code_colour>=39 && y_code_colour<=40))begin
                oled_data_colour = brown; end
            else if((x_code_colour==52) && (y_code_colour==40))begin
                oled_data_colour = brown; end
            else if((x_code_colour==54) && (y_code_colour==41))begin
                oled_data_colour = brown; end
            else if((x_code_colour>=52 && x_code_colour<=53) && (y_code_colour>=41 && y_code_colour<=45))begin
                oled_data_colour = brown; end
            else if((x_code_colour>=51 && x_code_colour<=52) && (y_code_colour>=46 && y_code_colour<=47))begin
                oled_data_colour = brown; end
            else if((x_code_colour==51) && (y_code_colour==45))begin
                oled_data_colour = brown; end
            else if((x_code_colour==49) && (y_code_colour==50))begin
                oled_data_colour = brown; end
            else if((x_code_colour>=43 && x_code_colour<=49) && (y_code_colour==51))begin
                oled_data_colour = brown; end
            else if((x_code_colour==44) && (y_code_colour>=52 && y_code_colour<=54))begin
                oled_data_colour = brown; end
            else if((x_code_colour==43) && (y_code_colour>=53 && y_code_colour<=55))begin
                oled_data_colour = brown; end
            else if((x_code_colour>=40 && x_code_colour<=42) && (y_code_colour==55))begin
                oled_data_colour = brown; end
            else if((x_code_colour==39) && (y_code_colour==54))begin
                oled_data_colour = brown; end
            else if((x_code_colour==38) && (y_code_colour>=52 && y_code_colour<=53))begin
                oled_data_colour = brown; end
            else if((x_code_colour==39) && (y_code_colour==51))begin
                oled_data_colour = brown; end
            else if((x_code_colour>=40 && x_code_colour<=42) && (y_code_colour==50))begin
                oled_data_colour = brown; end                     
            else if((x_code_colour>=39 && x_code_colour<=42) && (y_code_colour>=62 && y_code_colour<=63))begin
                oled_data_colour = brown; end                     
            else if((x_code_colour>=40 && x_code_colour<=41) && (y_code_colour==61))begin
                oled_data_colour = brown; end                     
            else if((x_code_colour==41) && (y_code_colour==60))begin
                oled_data_colour = brown; end   
            else if((x_code_colour>=52 && x_code_colour<=53) && (y_code_colour==62))begin
                oled_data_colour = brown; end   
            else if((x_code_colour>=52 && x_code_colour<=55) && (y_code_colour>=59 && y_code_colour<=61))begin
                oled_data_colour = brown; end                        
            else if((x_code_colour==53) && (y_code_colour>=57 && y_code_colour<=58))begin
                oled_data_colour = brown; end                      
                    
            else begin 
                oled_data_colour = white;
            end

        end // end of stage1 = 0 (locked screen)            
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        if(stage1==1)begin // display unlocked screen stage
            // lock display
            if((x_code_colour>32 && x_code_colour<62) && (y_code_colour>= 13 && y_code_colour<= 30))begin
                oled_data_colour  = yellow; end
            else if((x_code_colour>52 && x_code_colour<58) && (y_code_colour>= 7 && y_code_colour<= 12))begin
                oled_data_colour  = red; end
            else if((x_code_colour>68 && x_code_colour<74) && (y_code_colour>= 8 && y_code_colour<= 12))begin
                oled_data_colour  = red; end
            else if((x_code_colour>53 && x_code_colour<62) && (y_code_colour>= 3 && y_code_colour<= 6))begin
                oled_data_colour  = red; end
            else if((x_code_colour>66 && x_code_colour<74) && (y_code_colour>= 5 && y_code_colour<= 7))begin
                oled_data_colour  =red;end
            else if((x_code_colour>62 && x_code_colour<66) && (y_code_colour>= 2 && y_code_colour<= 4))begin
                oled_data_colour  = red; end
            else if((x_code_colour>60 && x_code_colour<72) && (y_code_colour>= 2 && y_code_colour<= 4))begin
                oled_data_colour  = red;end
            else if((x_code_colour>60 && x_code_colour<66) && (y_code_colour == 1))begin
                oled_data_colour  = red; end
            
            // jumped mario display, height start with 35th pixels
            else if((x_code_colour>42 && x_code_colour<50) && (y_code_colour==31))begin
                oled_data_colour  = brown; end     
            else if((x_code_colour>=42 && x_code_colour<=43) && (y_code_colour==32))begin
                oled_data_colour  = brown; end                   
            else if((x_code_colour==51) && (y_code_colour>=33 && y_code_colour <=35))begin
                oled_data_colour  = brown; end                     
            else if((x_code_colour==41) && (y_code_colour>=33 && y_code_colour <=34))begin
                oled_data_colour  = brown; end                     
            else if((x_code_colour==40) && (y_code_colour>=34 && y_code_colour <=36))begin
                oled_data_colour  = brown; end                 
            else if((x_code_colour==39) && (y_code_colour>=36 && y_code_colour <=37))begin
                oled_data_colour  = brown; end                    
            else if((x_code_colour>=38 && x_code_colour<=40) && (y_code_colour==38))begin
                oled_data_colour  = brown; end      
                    
            else if((x_code_colour>=44 && x_code_colour<=48) && (y_code_colour==32))begin
                oled_data_colour  = red; end  
            else if((x_code_colour>=42 && x_code_colour<=50) && (y_code_colour==33))begin
                oled_data_colour  = red; end                             
            else if((x_code_colour>=42 && x_code_colour<=50) && (y_code_colour==34))begin
                oled_data_colour  = red; end                             
            else if((x_code_colour>=41 && x_code_colour<=45) && (y_code_colour==35))begin
                oled_data_colour  = red; end                                
            else if((x_code_colour>=49 && x_code_colour<=50) && (y_code_colour==35))begin
                oled_data_colour  = red; end                              
                            
            else if((x_code_colour>=44 && x_code_colour<=51) && (y_code_colour>=37 && y_code_colour<=38))begin
                oled_data_colour  = black; end                             
            else if((x_code_colour>=48 && x_code_colour<=49) && (y_code_colour==39))begin
                oled_data_colour  = black; end                              
            else if((x_code_colour>=42 && x_code_colour<=43) && (y_code_colour>=38 && y_code_colour<=42))begin
                oled_data_colour  = black; end                              
            else if((x_code_colour>=42 && x_code_colour<=48) && (y_code_colour==44))begin
                oled_data_colour  = black; end                             
            else if((x_code_colour>=44 && x_code_colour<=49) && (y_code_colour==45))begin
                oled_data_colour  = black; end  
            else if((x_code_colour==45) && (y_code_colour>=40 && y_code_colour<=41))begin
                oled_data_colour  = black; end                                          
            else if((x_code_colour==47) && (y_code_colour>=40 && y_code_colour<=41))begin
                oled_data_colour  = black; end                                         
            else if((x_code_colour==44) && (y_code_colour==51))begin
                oled_data_colour  = black; end                                                
            else if((x_code_colour==47) && (y_code_colour>=48 && y_code_colour<=51))begin
                oled_data_colour  = black; end 
            else if((x_code_colour==50) && (y_code_colour>=50 && y_code_colour<=51))begin
                oled_data_colour  = black; end
            else if((x_code_colour==51) && (y_code_colour==52))begin
                oled_data_colour  = black; end
            else if((x_code_colour==50) && (y_code_colour==48))begin
                oled_data_colour  = black; end                     
            
            else if((x_code_colour==40) && (y_code_colour>=52 && y_code_colour<=55))begin
                oled_data_colour  = dark_blue; end
            else if((x_code_colour==41) && (y_code_colour>=53 && y_code_colour<=55))begin
                oled_data_colour  = dark_blue; end
            else if((x_code_colour==42) && (y_code_colour>=55 && y_code_colour<=57))begin
                oled_data_colour  = dark_blue; end
            else if((x_code_colour==43) && (y_code_colour>=56 && y_code_colour<=58))begin
                oled_data_colour  = dark_blue; end
            else if((x_code_colour==51) && (y_code_colour>=53 && y_code_colour<=57))begin
                oled_data_colour  = dark_blue; end
            else if((x_code_colour==52) && (y_code_colour>=50 && y_code_colour<=54))begin
                oled_data_colour  = dark_blue; end
            else if((x_code_colour==53) && (y_code_colour>=50 && y_code_colour<=51))begin
                oled_data_colour  = dark_blue; end
            else if((x_code_colour>=44 && x_code_colour<=45) && (y_code_colour==57))begin
                oled_data_colour  = dark_blue; end
            else if((x_code_colour>=44 && x_code_colour<=47) && (y_code_colour==58))begin
                oled_data_colour  = dark_blue; end
            else if((x_code_colour==54) && (y_code_colour==51))begin
                oled_data_colour  = dark_blue; end
            
            else if((x_code_colour==48) && (y_code_colour==49))begin
                oled_data_colour  = black_blue; end
            else if((x_code_colour==50) && (y_code_colour==49))begin
                oled_data_colour  = black_blue; end
            else if((x_code_colour==45) && (y_code_colour==49))begin
                oled_data_colour  = black_blue; end
            else if((x_code_colour==51) && (y_code_colour>=50 && y_code_colour<=51))begin
                oled_data_colour  = black_blue; end
            else if((x_code_colour>=50 && x_code_colour<=51) && (y_code_colour>=46 && y_code_colour<=47))begin
                oled_data_colour  = black_blue; end
            else if((x_code_colour>=51 && x_code_colour<=52) && (y_code_colour>=48 && y_code_colour<=49))begin
                oled_data_colour  = black_blue; end
            
            else if((x_code_colour>=41 && x_code_colour<=42) && (y_code_colour==52))begin
                oled_data_colour  = dark_green; end
            else if((x_code_colour>=43 && x_code_colour<=44) && (y_code_colour==55))begin
                oled_data_colour  = dark_green; end
            else if((x_code_colour>=44 && x_code_colour<=46) && (y_code_colour==56))begin
                oled_data_colour  = dark_green; end
            else if((x_code_colour>=46 && x_code_colour<=47) && (y_code_colour==57))begin
                oled_data_colour  = dark_green; end
            else if((x_code_colour==42) && (y_code_colour>=53 && y_code_colour<=54))begin
                oled_data_colour  = dark_green; end
            
            else if((x_code_colour==47) && (y_code_colour>=52 && y_code_colour<=56))begin
                oled_data_colour  = light_green; end
            else if((x_code_colour==50) && (y_code_colour>=52 && y_code_colour<=57))begin
                oled_data_colour  = light_green; end  
            else if((x_code_colour>=43 && x_code_colour<=44) && (y_code_colour>=52 && y_code_colour<=54))begin
                oled_data_colour  = light_green; end                     
            else if((x_code_colour>=45 && x_code_colour<=46) && (y_code_colour>=54 && y_code_colour<=55))begin
                oled_data_colour  = light_green; end                     
            else if((x_code_colour>=48 && x_code_colour<=49) && (y_code_colour>=54 && y_code_colour<=57))begin
                oled_data_colour  = light_green; end                     
                    
            else if((x_code_colour>=45 && x_code_colour<=46) && (y_code_colour==51))begin
                oled_data_colour  = green1; end                     
            else if((x_code_colour>=48 && x_code_colour<=49) && (y_code_colour==51))begin
                oled_data_colour  = green1; end                     
                    
            else if((x_code_colour>=45 && x_code_colour<=46) && (y_code_colour==50))begin
                oled_data_colour  = green2; end                     
            else if((x_code_colour>=48 && x_code_colour<=49) && (y_code_colour==50))begin
                oled_data_colour  = green2; end                     
            
            else if((x_code_colour>=49 && x_code_colour<=51) && (y_code_colour==44))begin
                oled_data_colour  = dark_red; end
            else if((x_code_colour>=50 && x_code_colour<=51) && (y_code_colour==45))begin
                oled_data_colour  = dark_red; end
            
            else if((x_code_colour>=45 && x_code_colour<=46) && (y_code_colour==48))begin
                oled_data_colour  = purple; end
            else if((x_code_colour>=48 && x_code_colour<=49) && (y_code_colour==48))begin
                oled_data_colour  = purple; end
            else if((x_code_colour==46) && (y_code_colour==49))begin
                oled_data_colour  = purple; end
            else if((x_code_colour==49) && (y_code_colour==49))begin
                oled_data_colour  = purple; end
            
            else if((x_code_colour>=44 && x_code_colour<=48) && (y_code_colour==42))begin
                oled_data_colour  = skin_lock; end
            else if((x_code_colour>=42 && x_code_colour<=48) && (y_code_colour==43))begin
                oled_data_colour  = skin_lock; end
            else if((x_code_colour>=41 && x_code_colour<=43) && (y_code_colour==45))begin
                oled_data_colour  = skin_lock; end
            else if((x_code_colour>=43 && x_code_colour<=48) && (y_code_colour==46))begin
                oled_data_colour  = skin_lock; end
            else if((x_code_colour>=49 && x_code_colour<=50) && (y_code_colour>=40 && y_code_colour<=43))begin
                oled_data_colour  = skin_lock; end
            else if((x_code_colour>=40 && x_code_colour<=41) && (y_code_colour>=43 && y_code_colour<=44))begin
                oled_data_colour  = skin_lock; end                     
            else if((x_code_colour==46) && (y_code_colour>=39 && y_code_colour<=41))begin
                oled_data_colour  = skin_lock; end
            
            else if((x_code_colour==41) && (y_code_colour>=36 && y_code_colour<=42))begin
                oled_data_colour  = orange; end
            else if((x_code_colour>=42 && x_code_colour<=43) && (y_code_colour>=36 && y_code_colour<=37))begin
                oled_data_colour  = orange; end
            else if((x_code_colour>=50 && x_code_colour<=51) && (y_code_colour==36))begin
                oled_data_colour  = orange; end                     
                    
            else if((x_code_colour>=46 && x_code_colour<=47) && (y_code_colour>=35 && y_code_colour<=36))begin
                oled_data_colour  = yellow; end
            else if((x_code_colour==45) && (y_code_colour==36))begin
                oled_data_colour  = yellow; end
            
            
            else if((x_code_colour>=53 && x_code_colour<=54) && (y_code_colour>=32 && y_code_colour<=33))begin
                oled_data_colour  = brown; end
            else if((x_code_colour==56) && (y_code_colour>=32 && y_code_colour<=35))begin
                oled_data_colour  = brown; end
            else if((x_code_colour==55) && (y_code_colour>=34 && y_code_colour<=35))begin
                oled_data_colour  = brown; end
            else if((x_code_colour>=53 && x_code_colour<=54) && (y_code_colour>=35 && y_code_colour<=36))begin
                oled_data_colour  = brown; end
            else if((x_code_colour==52) && (y_code_colour==36))begin
                oled_data_colour  = brown; end
            else if((x_code_colour==54) && (y_code_colour==37))begin
                oled_data_colour  = brown; end
            else if((x_code_colour>=52 && x_code_colour<=53) && (y_code_colour>=37 && y_code_colour<=41))begin
                oled_data_colour  = brown; end
            else if((x_code_colour>=51 && x_code_colour<=52) && (y_code_colour>=42 && y_code_colour<=43))begin
                oled_data_colour  = brown; end
            else if((x_code_colour==51) && (y_code_colour==41))begin
                oled_data_colour  = brown; end
            else if((x_code_colour==49) && (y_code_colour==46))begin
                oled_data_colour  = brown; end
            else if((x_code_colour>=43 && x_code_colour<=49) && (y_code_colour==47))begin
                oled_data_colour  = brown; end
            else if((x_code_colour==44) && (y_code_colour>=48 && y_code_colour<=50))begin
                oled_data_colour  = brown; end
            else if((x_code_colour==43) && (y_code_colour>=49 && y_code_colour<=51))begin
                oled_data_colour  = brown; end
            else if((x_code_colour>=40 && x_code_colour<=42) && (y_code_colour==51))begin
                oled_data_colour  = brown; end
            else if((x_code_colour==39) && (y_code_colour==50))begin
                oled_data_colour  = brown; end
            else if((x_code_colour==38) && (y_code_colour>=48 && y_code_colour<=49))begin
                oled_data_colour  = brown; end
            else if((x_code_colour==39) && (y_code_colour==47))begin
                oled_data_colour  = brown; end
            else if((x_code_colour>=40 && x_code_colour<=42) && (y_code_colour==46))begin
                oled_data_colour  = brown; end                     
            else if((x_code_colour>=39 && x_code_colour<=42) && (y_code_colour>=58 && y_code_colour<=59))begin
                oled_data_colour  = brown; end                     
            else if((x_code_colour>=40 && x_code_colour<=41) && (y_code_colour==57))begin
                oled_data_colour  = brown; end                     
            else if((x_code_colour==41) && (y_code_colour==56))begin
                oled_data_colour  = brown; end   
            else if((x_code_colour>=52 && x_code_colour<=53) && (y_code_colour==58))begin
                oled_data_colour  = brown; end   
            else if((x_code_colour>=52 && x_code_colour<=55) && (y_code_colour>=55 && y_code_colour<=57))begin
                oled_data_colour  = brown; end                        
            else if((x_code_colour==53) && (y_code_colour>=53 && y_code_colour<=54))begin
                oled_data_colour  = brown; end                      
            
            else begin 
                oled_data_colour  = white;
            end
            
        end // end of stage1 = 1 (unlocked screen)    

        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        if(stage1==2 && game_mode==0)begin //when unlocked. If(game_mode==0) begin, just running of basic requirement until pushCenter is pressed
            if(state_colour != 0 && push_game) begin  //when push_game aka pushCenter is pushed, enter flappy bird game 
                game_mode=1;
            end  
            
            if(state_colour != 0 && sw[11] && !sw[10] && !sw[9]) begin 
                stage = 1; // yellow colour thheme
            end
             
            if(state_colour != 0 && sw[10] && !sw[9] && !sw[11]) begin 
                stage = 2; // blue colour thheme
            end
            
            if(state_colour != 0 && sw[9] && !sw[10] && !sw[11]) begin
                stage = 3; // circle theme
            end
            
            if(!sw[9] && !sw[10] && !sw[11]) begin
                stage = 0; // default colour theme
            end
              
            if(stage == 0) begin //default colour theme: black background, green, yellow, red bars, and white borders
                if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 5 && y_code_colour<= 21 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==16  ) begin  // all red bar
                    oled_data_colour = 16'b11111_000000_00000;
                end
                
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 8 && y_code_colour<= 21 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==15  ) begin
                    oled_data_colour = 16'b11111_000000_00000;
                end   
                       
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 11 && y_code_colour<= 21 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==14  ) begin
                    oled_data_colour = 16'b11111_000000_00000;
                end      
                    
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 15 && y_code_colour<= 21 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==13  ) begin
                    oled_data_colour = 16'b11111_000000_00000;
                end    
                          
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 19 && y_code_colour<= 21 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==12  ) begin
                    oled_data_colour = 16'b11111_000000_00000;
                end      
                     
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 23 && y_code_colour<= 39 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour>=11 ) begin // all yellow bar
                    oled_data_colour = 16'b11111_111111_00000;
                end    
                          
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 26 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==10  ) begin
                    oled_data_colour = 16'b11111_111111_00000;
                end     
                         
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 29 && y_code_colour<= 39 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==9  ) begin
                    oled_data_colour = 16'b11111_111111_00000;
                end        
                      
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 33 && y_code_colour<= 39 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==8  ) begin
                    oled_data_colour = 16'b11111_111111_00000;
                end      
                        
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 37 && y_code_colour<= 39 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==7  ) begin
                    oled_data_colour = 16'b11111_111111_00000;
                end      
                         
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 41 && y_code_colour<= 60 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour>=6 ) begin // all green bar
                    oled_data_colour = 16'b00000_111111_00000;
                end 
                        
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 44 && y_code_colour<= 60 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==5  ) begin
                    oled_data_colour = 16'b00000_111111_00000;
                end      
                          
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 47 && y_code_colour<= 60 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==4  ) begin
                    oled_data_colour = 16'b00000_111111_00000;
                end    
                            
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 50 && y_code_colour<= 60 && (y_code_colour !=53 && y_code_colour !=57)) && state_colour==3  ) begin
                    oled_data_colour = 16'b00000_111111_00000;
                end       
                     
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 54 && y_code_colour<= 60 && (y_code_colour != 57)) && state_colour==2  ) begin
                    oled_data_colour = 16'b00000_111111_00000;
                end  
                
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 58 && y_code_colour<= 60) && state_colour==1  ) begin
                    oled_data_colour = 16'b00000_111111_00000;
                end
                            
                else begin
                    oled_data_colour = 16'b0;
                end
                
            end // end of standard colour theme
       
            if(stage == 1) begin //2nd colour theme: shades of orange bars with green border   
                if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 5 && y_code_colour<= 21 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==16  ) begin // all red bar
                    oled_data_colour = 16'hF9E0;
                end
                
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 8 && y_code_colour<= 21 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==15  ) begin
                    oled_data_colour = 16'hF9E0;
                end        
                      
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 11 && y_code_colour<= 21 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==14  ) begin
                    oled_data_colour = 16'hFA80;
                end        
                      
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 15 && y_code_colour<= 21 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==13  ) begin
                    oled_data_colour = 16'hFB40;
                end      
                        
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 19 && y_code_colour<= 21 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==12  ) begin
                    oled_data_colour = 16'hFC00;
                end        
                     
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 23 && y_code_colour<= 39 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour>=11 ) begin // all yellow bar
                    oled_data_colour = 16'hFCA0;
                end      
                    
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 26 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==10  ) begin
                    oled_data_colour = 16'hFD60;
                end   
                           
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 29 && y_code_colour<= 39 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==9  ) begin
                    oled_data_colour = 16'hFE20;
                end  
                            
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 33 && y_code_colour<= 39 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==8  ) begin
                    oled_data_colour = 16'hFEC0;
                end         
                     
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 37 && y_code_colour<= 39 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==7  ) begin
                    oled_data_colour = 16'hFF80;
                end 
                              
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 41 && y_code_colour<= 60 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour>=6 ) begin // all green bar
                    oled_data_colour = 16'hEFE0;
                end  
                       
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 44 && y_code_colour<= 60 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==5  ) begin
                    oled_data_colour = 16'hCFE0;
                end   
                             
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 47 && y_code_colour<= 60 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==4  ) begin
                    oled_data_colour = 16'hB7E0;
                end  
                              
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 50 && y_code_colour<= 60 && (y_code_colour !=53 && y_code_colour !=57)) && state_colour==3  ) begin
                    oled_data_colour = 16'h9FE0;
                end   
                             
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 54 && y_code_colour<= 60 && (y_code_colour != 57)) && state_colour==2  ) begin
                    oled_data_colour = 16'h6FE0;
                end  
                    
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 58 && y_code_colour<= 60) && state_colour==1  ) begin
                    oled_data_colour = 16'h6FE0;
                end      
                          
                else begin
                    oled_data_colour = 16'b0;
                end
                    
            end // end of 2nd colour theme
             
            if(stage == 2) begin // 3rd colour theme: shades of blue bars with white background, and cyan border    
                if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 5 && y_code_colour<= 21 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==16  )begin // all red bar
                    oled_data_colour = 16'h0869;
                end
                
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 8 && y_code_colour<= 21 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==15  )begin
                    oled_data_colour = 16'h10AE;
                end 
                         
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 11 && y_code_colour<= 21 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==14  )begin
                    oled_data_colour = 16'h10B0;
                end  
                        
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 15 && y_code_colour<= 21 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==13  )begin
                    oled_data_colour = 16'h10D3;
                end 
                         
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 19 && y_code_colour<= 21 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==12  )begin
                    oled_data_colour = 16'h0076;
                end
                       
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 23 && y_code_colour<= 39 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour>=11 )begin // all yellow bar
                    oled_data_colour = 16'h00FF;
                end 
                         
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 26 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==10  )begin
                    oled_data_colour = 16'h01BF;
                end 
                         
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 29 && y_code_colour<= 39 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==9  )begin
                    oled_data_colour = 16'h027F;
                end 
                         
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 33 && y_code_colour<= 39 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==8  )begin
                    oled_data_colour = 16'h031F;
                end 
                         
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 37 && y_code_colour<= 39 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==7  )begin
                    oled_data_colour = 16'h03DF;
                end 
                         
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 41 && y_code_colour<= 60 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour>=6 )begin // all green bar
                    oled_data_colour = 16'h04DF;
                end 
                    
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 44 && y_code_colour<= 60 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==5  )begin
                    oled_data_colour = 16'h053F;
                end 
                           
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 47 && y_code_colour<= 60 && (y_code_colour !=4 && y_code_colour !=7 && y_code_colour !=10 && y_code_colour !=14 && y_code_colour !=18 && y_code_colour !=22 && y_code_colour !=25 && y_code_colour !=28 && y_code_colour !=32 && y_code_colour !=36 && y_code_colour !=40 && y_code_colour !=43 && y_code_colour !=46 && y_code_colour !=49 && y_code_colour !=53 && y_code_colour !=57)) && state_colour==4  )begin
                    oled_data_colour = 16'h05FF;
                end 
                           
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 50 && y_code_colour<= 60 && (y_code_colour !=53 && y_code_colour !=57)) && state_colour==3  )begin
                    oled_data_colour = 16'h06FF;
                end 
                           
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 54 && y_code_colour<= 60 && (y_code_colour != 57)) && state_colour==2  )begin
                    oled_data_colour = 16'h07BF;
                end 
                 
                else if((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 58 && y_code_colour<= 60) && state_colour==1  )begin
                    oled_data_colour = 16'h07FF;
                end 
                           
                else begin
                    oled_data_colour = 16'b11111_111111_11111;
                end
                
            end // end of 3rd colour theme
            
            if(stage == 3) begin // circle theme
                if(state_colour==1)begin 
                    oled_data_colour = white; 
                    if(x_code_colour==47||y_code_colour==31)begin 
                        oled_data_colour = black;end
                    if(((x_code_colour-47)*(x_code_colour-47) + (y_code_colour-31)*(y_code_colour-31)<= 2*2) && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour1;end
                end
                
                if(state_colour==2)begin 
                    oled_data_colour = white; 
                    if(x_code_colour==47||y_code_colour==31)begin 
                        oled_data_colour = black;end
                    if((x_code_circle + y_code_circle)<= 2*2 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour1;end
                    if((x_code_circle + y_code_circle) > 2*2 && (x_code_circle + y_code_circle)<= 4*4 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour2;end
                end
                    
                if(state_colour==3)begin  
                    oled_data_colour = white; 
                    if(x_code_colour==47||y_code_colour==31)begin 
                        oled_data_colour = black;end
                    if((x_code_circle + y_code_circle)<= 2*2 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour1;end
                    if((x_code_circle + y_code_circle) > 2*2 && (x_code_circle + y_code_circle)<= 4*4 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour2;end
                    if((x_code_circle + y_code_circle) > 4*4 && (x_code_circle + y_code_circle)<= 6*6 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour3;end
                end
          
                if(state_colour==4)begin 
                    oled_data_colour = white; 
                    if(x_code_colour==47||y_code_colour==31)begin 
                        oled_data_colour = black;end
                    if((x_code_circle + y_code_circle)<= 2*2 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour1;end
                    if((x_code_circle + y_code_circle) > 2*2 && (x_code_circle + y_code_circle)<= 4*4 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour2;end
                    if((x_code_circle + y_code_circle) > 4*4 && (x_code_circle + y_code_circle)<= 6*6 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour3;end
                    if((x_code_circle + y_code_circle) > 6*6 && (x_code_circle + y_code_circle)<= 8*8 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour4;end
                end
          
                if(state_colour==5)begin 
                    oled_data_colour = white; 
                    if(x_code_colour==47||y_code_colour==31)begin 
                        oled_data_colour = black;end
                    if((x_code_circle + y_code_circle)<= 2*2 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour1;end
                    if((x_code_circle + y_code_circle) > 2*2 && (x_code_circle + y_code_circle)<= 4*4 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour2;end
                    if((x_code_circle + y_code_circle) > 4*4 && (x_code_circle + y_code_circle)<= 6*6 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour3;end
                    if((x_code_circle + y_code_circle) > 6*6 && (x_code_circle + y_code_circle)<= 8*8 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour4;end
                    if((x_code_circle + y_code_circle) > 6*6 && (x_code_circle + y_code_circle)<= 8*8 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour4;end
                    if((x_code_circle + y_code_circle) > 8*8 && (x_code_circle + y_code_circle)<= 10*10 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour5;end                
                end        
                
                if(state_colour==6)begin 
                    oled_data_colour = white; 
                    if(x_code_colour==47||y_code_colour==31)begin 
                        oled_data_colour = black;end
                    if((x_code_circle + y_code_circle)<= 2*2 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour1;end
                    if((x_code_circle + y_code_circle) > 2*2 && (x_code_circle + y_code_circle)<= 4*4 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour2;end
                    if((x_code_circle + y_code_circle) > 4*4 && (x_code_circle + y_code_circle)<= 6*6 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour3;end
                    if((x_code_circle + y_code_circle) > 6*6 && (x_code_circle + y_code_circle)<= 8*8 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour4;end
                    if((x_code_circle + y_code_circle) > 6*6 && (x_code_circle + y_code_circle)<= 8*8 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour4;end
                    if((x_code_circle + y_code_circle) > 8*8 && (x_code_circle + y_code_circle)<= 10*10 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour5;end      
                    if((x_code_circle + y_code_circle) > 10*10 && (x_code_circle + y_code_circle)<= 12*12 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour6;end                                 
                end                
                    
                if(state_colour==7)begin oled_data_colour = colour6; 
                    oled_data_colour = white; 
                    if(x_code_colour==47||y_code_colour==31)begin 
                        oled_data_colour = black;end
                    if((x_code_circle + y_code_circle)<= 2*2 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour1;end
                    if((x_code_circle + y_code_circle) > 2*2 && (x_code_circle + y_code_circle)<= 4*4 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour2;end
                    if((x_code_circle + y_code_circle) > 4*4 && (x_code_circle + y_code_circle)<= 6*6 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour3;end
                    if((x_code_circle + y_code_circle) > 6*6 && (x_code_circle + y_code_circle)<= 8*8 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour4;end
                    if((x_code_circle + y_code_circle) > 6*6 && (x_code_circle + y_code_circle)<= 8*8 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour4;end
                    if((x_code_circle + y_code_circle) > 8*8 && (x_code_circle + y_code_circle)<= 10*10 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour5;end      
                    if((x_code_circle + y_code_circle) > 10*10 && (x_code_circle + y_code_circle)<= 12*12 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour6;end    
                    if((x_code_circle + y_code_circle) > 12*12 && (x_code_circle + y_code_circle)<= 14*14 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour7;end   
                end    
            
                if(state_colour==8)begin 
                    oled_data_colour = white; 
                    if(x_code_colour==47||y_code_colour==31)begin 
                        oled_data_colour = black;end
                    if((x_code_circle + y_code_circle)<= 2*2 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour1;end
                    if((x_code_circle + y_code_circle) > 2*2 && (x_code_circle + y_code_circle)<= 4*4 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour2;end
                    if((x_code_circle + y_code_circle) > 4*4 && (x_code_circle + y_code_circle)<= 6*6 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour3;end
                    if((x_code_circle + y_code_circle) > 6*6 && (x_code_circle + y_code_circle)<= 8*8 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour4;end
                    if((x_code_circle + y_code_circle) > 6*6 && (x_code_circle + y_code_circle)<= 8*8 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour4;end
                    if((x_code_circle + y_code_circle) > 8*8 && (x_code_circle + y_code_circle)<= 10*10 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour5;end      
                    if((x_code_circle + y_code_circle) > 10*10 && (x_code_circle + y_code_circle)<= 12*12 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour6;end    
                    if((x_code_circle + y_code_circle) > 12*12 && (x_code_circle + y_code_circle)<= 14*14 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour7;end   
                    if((x_code_circle + y_code_circle) > 14*14 && (x_code_circle + y_code_circle)<= 16*16 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour7;end                     
                end          
                    
                if(state_colour==9)begin 
                    oled_data_colour = white; 
                    if(x_code_colour==47||y_code_colour==31)begin 
                        oled_data_colour = black;end
                    if((x_code_circle + y_code_circle)<= 2*2 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour1;end
                    if((x_code_circle + y_code_circle) > 2*2 && (x_code_circle + y_code_circle)<= 4*4 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour2;end
                    if((x_code_circle + y_code_circle) > 4*4 && (x_code_circle + y_code_circle)<= 6*6 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour3;end
                    if((x_code_circle + y_code_circle) > 6*6 && (x_code_circle + y_code_circle)<= 8*8 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour4;end
                    if((x_code_circle + y_code_circle) > 6*6 && (x_code_circle + y_code_circle)<= 8*8 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour4;end
                    if((x_code_circle + y_code_circle) > 8*8 && (x_code_circle + y_code_circle)<= 10*10 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour5;end      
                    if((x_code_circle + y_code_circle) > 10*10 && (x_code_circle + y_code_circle)<= 12*12 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour6;end    
                    if((x_code_circle + y_code_circle) > 12*12 && (x_code_circle + y_code_circle)<= 14*14 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour7;end   
                    if((x_code_circle + y_code_circle) > 14*14 && (x_code_circle + y_code_circle)<= 16*16 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour7;end     
                    if((x_code_circle + y_code_circle) > 16*16 && (x_code_circle + y_code_circle)<= 18*18 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour8;end  
                end        
            
                if(state_colour==10)begin 
                    oled_data_colour = white; 
                    if(x_code_colour==47||y_code_colour==31)begin
                        oled_data_colour = black;end
                    if((x_code_circle + y_code_circle)<= 2*2 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour1;end
                    if((x_code_circle + y_code_circle) > 2*2 && (x_code_circle + y_code_circle)<= 4*4 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour2;end
                    if((x_code_circle + y_code_circle) > 4*4 && (x_code_circle + y_code_circle)<= 6*6 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour3;end
                    if((x_code_circle + y_code_circle) > 6*6 && (x_code_circle + y_code_circle)<= 8*8 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour4;end
                    if((x_code_circle + y_code_circle) > 6*6 && (x_code_circle + y_code_circle)<= 8*8 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour4;end
                    if((x_code_circle + y_code_circle) > 8*8 && (x_code_circle + y_code_circle)<= 10*10 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour5;end      
                    if((x_code_circle + y_code_circle) > 10*10 && (x_code_circle + y_code_circle)<= 12*12 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour6;end    
                    if((x_code_circle + y_code_circle) > 12*12 && (x_code_circle + y_code_circle)<= 14*14 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour7;end   
                    if((x_code_circle + y_code_circle) > 14*14 && (x_code_circle + y_code_circle)<= 16*16 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour7;end     
                    if((x_code_circle + y_code_circle) > 16*16 && (x_code_circle + y_code_circle)<= 18*18 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour8;end  
                    if((x_code_circle + y_code_circle) > 18*18 && (x_code_circle + y_code_circle)<= 20*20 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour9;end                     
                end       
                    
                if(state_colour==11)begin 
                    oled_data_colour = white; 
                    if(x_code_colour==47||y_code_colour==31)begin 
                        oled_data_colour = black;end
                    if((x_code_circle + y_code_circle)<= 2*2 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour1;end
                    if((x_code_circle + y_code_circle) > 2*2 && (x_code_circle + y_code_circle)<= 4*4 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour2;end
                    if((x_code_circle + y_code_circle) > 4*4 && (x_code_circle + y_code_circle)<= 6*6 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour3;end
                    if((x_code_circle + y_code_circle) > 6*6 && (x_code_circle + y_code_circle)<= 8*8 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour4;end
                    if((x_code_circle + y_code_circle) > 6*6 && (x_code_circle + y_code_circle)<= 8*8 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour4;end
                    if((x_code_circle + y_code_circle) > 8*8 && (x_code_circle + y_code_circle)<= 10*10 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour5;end      
                    if((x_code_circle + y_code_circle) > 10*10 && (x_code_circle + y_code_circle)<= 12*12 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour6;end    
                    if((x_code_circle + y_code_circle) > 12*12 && (x_code_circle + y_code_circle)<= 14*14 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour7;end   
                    if((x_code_circle + y_code_circle) > 14*14 && (x_code_circle + y_code_circle)<= 16*16 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour7;end     
                    if((x_code_circle + y_code_circle) > 16*16 && (x_code_circle + y_code_circle)<= 18*18 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour8;end  
                    if((x_code_circle + y_code_circle) > 18*18 && (x_code_circle + y_code_circle)<= 20*20 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour9;end           
                    if((x_code_circle + y_code_circle) > 20*20 && (x_code_circle + y_code_circle)<= 22*22 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour10;end                   
                end        
                    
                if(state_colour==12)begin 
                    oled_data_colour = white; 
                    if(x_code_colour==47||y_code_colour==31)begin 
                        oled_data_colour = black;end
                    if((x_code_circle + y_code_circle)<= 2*2 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour1;end
                    if((x_code_circle + y_code_circle) > 2*2 && (x_code_circle + y_code_circle)<= 4*4 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour2;end
                    if((x_code_circle + y_code_circle) > 4*4 && (x_code_circle + y_code_circle)<= 6*6 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour3;end
                    if((x_code_circle + y_code_circle) > 6*6 && (x_code_circle + y_code_circle)<= 8*8 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour4;end
                    if((x_code_circle + y_code_circle) > 6*6 && (x_code_circle + y_code_circle)<= 8*8 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour4;end
                    if((x_code_circle + y_code_circle) > 8*8 && (x_code_circle + y_code_circle)<= 10*10 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour5;end      
                    if((x_code_circle + y_code_circle) > 10*10 && (x_code_circle + y_code_circle)<= 12*12 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour6;end    
                    if((x_code_circle + y_code_circle) > 12*12 && (x_code_circle + y_code_circle)<= 14*14 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour7;end   
                    if((x_code_circle + y_code_circle) > 14*14 && (x_code_circle + y_code_circle)<= 16*16 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour7;end     
                    if((x_code_circle + y_code_circle) > 16*16 && (x_code_circle + y_code_circle)<= 18*18 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour8;end  
                    if((x_code_circle + y_code_circle) > 18*18 && (x_code_circle + y_code_circle)<= 20*20 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour9;end           
                    if((x_code_circle + y_code_circle) > 20*20 && (x_code_circle + y_code_circle)<= 22*22 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour10;end        
                    if((x_code_circle + y_code_circle) > 22*22 && (x_code_circle + y_code_circle)<= 24*24 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour11;end               
                end   
    
                if(state_colour==13)begin 
                    oled_data_colour = white; 
                    if(x_code_colour==47||y_code_colour==31)begin 
                        oled_data_colour = black;end
                    if((x_code_circle + y_code_circle)<= 2*2 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour1;end
                    if((x_code_circle + y_code_circle) > 2*2 && (x_code_circle + y_code_circle)<= 4*4 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour2;end
                    if((x_code_circle + y_code_circle) > 4*4 && (x_code_circle + y_code_circle)<= 6*6 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour3;end
                    if((x_code_circle + y_code_circle) > 6*6 && (x_code_circle + y_code_circle)<= 8*8 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour4;end
                    if((x_code_circle + y_code_circle) > 6*6 && (x_code_circle + y_code_circle)<= 8*8 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour4;end
                    if((x_code_circle + y_code_circle) > 8*8 && (x_code_circle + y_code_circle)<= 10*10 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour5;end      
                    if((x_code_circle + y_code_circle) > 10*10 && (x_code_circle + y_code_circle)<= 12*12 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour6;end    
                    if((x_code_circle + y_code_circle) > 12*12 && (x_code_circle + y_code_circle)<= 14*14 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour7;end   
                    if((x_code_circle + y_code_circle) > 14*14 && (x_code_circle + y_code_circle)<= 16*16 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour7;end     
                    if((x_code_circle + y_code_circle) > 16*16 && (x_code_circle + y_code_circle)<= 18*18 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour8;end  
                    if((x_code_circle + y_code_circle) > 18*18 && (x_code_circle + y_code_circle)<= 20*20 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour9;end           
                    if((x_code_circle + y_code_circle) > 20*20 && (x_code_circle + y_code_circle)<= 22*22 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour10;end        
                    if((x_code_circle + y_code_circle) > 22*22 && (x_code_circle + y_code_circle)<= 24*24 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour11;end   
                    if((x_code_circle + y_code_circle) > 24*24 && (x_code_circle + y_code_circle)<= 26*26 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour12;end              
                end            
                                    
                if(state_colour==14)begin 
                    oled_data_colour = white; 
                    if(x_code_colour==47||y_code_colour==31)begin 
                        oled_data_colour = black;end
                    if((x_code_circle + y_code_circle)<= 2*2 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour1;end
                    if((x_code_circle + y_code_circle) > 2*2 && (x_code_circle + y_code_circle)<= 4*4 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour2;end
                    if((x_code_circle + y_code_circle) > 4*4 && (x_code_circle + y_code_circle)<= 6*6 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour3;end
                    if((x_code_circle + y_code_circle) > 6*6 && (x_code_circle + y_code_circle)<= 8*8 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour4;end
                    if((x_code_circle + y_code_circle) > 6*6 && (x_code_circle + y_code_circle)<= 8*8 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour4;end
                    if((x_code_circle + y_code_circle) > 8*8 && (x_code_circle + y_code_circle)<= 10*10 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour5;end      
                    if((x_code_circle + y_code_circle) > 10*10 && (x_code_circle + y_code_circle)<= 12*12 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour6;end    
                    if((x_code_circle + y_code_circle) > 12*12 && (x_code_circle + y_code_circle)<= 14*14 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour7;end   
                    if((x_code_circle + y_code_circle) > 14*14 && (x_code_circle + y_code_circle)<= 16*16 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour7;end     
                    if((x_code_circle + y_code_circle) > 16*16 && (x_code_circle + y_code_circle)<= 18*18 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour8;end  
                    if((x_code_circle + y_code_circle) > 18*18 && (x_code_circle + y_code_circle)<= 20*20 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour9;end           
                    if((x_code_circle + y_code_circle) > 20*20 && (x_code_circle + y_code_circle)<= 22*22 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour10;end        
                    if((x_code_circle + y_code_circle) > 22*22 && (x_code_circle + y_code_circle)<= 24*24 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour11;end   
                    if((x_code_circle + y_code_circle) > 24*24 && (x_code_circle + y_code_circle)<= 26*26 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour12;end     
                    if((x_code_circle + y_code_circle) > 26*26 && (x_code_circle + y_code_circle)<= 28*28 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour13;end              
                end            
                    
                if(state_colour==15)begin 
                    oled_data_colour = white; 
                    if(x_code_colour==47||y_code_colour==31)begin 
                        oled_data_colour = black;end
                    if((x_code_circle + y_code_circle)<= 2*2 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour1;end
                    if((x_code_circle + y_code_circle) > 2*2 && (x_code_circle + y_code_circle)<= 4*4 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour2;end
                    if((x_code_circle + y_code_circle) > 4*4 && (x_code_circle + y_code_circle)<= 6*6 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour3;end
                    if((x_code_circle + y_code_circle) > 6*6 && (x_code_circle + y_code_circle)<= 8*8 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour4;end
                    if((x_code_circle + y_code_circle) > 6*6 && (x_code_circle + y_code_circle)<= 8*8 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour4;end
                    if((x_code_circle + y_code_circle) > 8*8 && (x_code_circle + y_code_circle)<= 10*10 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour5;end      
                    if((x_code_circle + y_code_circle) > 10*10 && (x_code_circle + y_code_circle)<= 12*12 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour6;end    
                    if((x_code_circle + y_code_circle) > 12*12 && (x_code_circle + y_code_circle)<= 14*14 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour7;end   
                    if((x_code_circle + y_code_circle) > 14*14 && (x_code_circle + y_code_circle)<= 16*16 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour7;end     
                    if((x_code_circle + y_code_circle) > 16*16 && (x_code_circle + y_code_circle)<= 18*18 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour8;end  
                    if((x_code_circle + y_code_circle) > 18*18 && (x_code_circle + y_code_circle)<= 20*20 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour9;end           
                    if((x_code_circle + y_code_circle) > 20*20 && (x_code_circle + y_code_circle)<= 22*22 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour10;end        
                    if((x_code_circle + y_code_circle) > 22*22 && (x_code_circle + y_code_circle)<= 24*24 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour11;end   
                    if((x_code_circle + y_code_circle) > 24*24 && (x_code_circle + y_code_circle)<= 26*26 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour12;end     
                    if((x_code_circle + y_code_circle) > 26*26 && (x_code_circle + y_code_circle)<= 28*28 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour13;end      
                    if((x_code_circle + y_code_circle) > 28*28 && (x_code_circle + y_code_circle)<= 30*30 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour14;end           
                end         
                         
                if(state_colour==16)begin 
                    oled_data_colour = white; 
                    if(x_code_colour==47||y_code_colour==31)begin 
                        oled_data_colour = black;end
                    if((x_code_circle + y_code_circle)<= 2*2 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour1;end
                    if((x_code_circle + y_code_circle) > 2*2 && (x_code_circle + y_code_circle)<= 4*4 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour2;end
                    if((x_code_circle + y_code_circle) > 4*4 && (x_code_circle + y_code_circle)<= 6*6 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour3;end
                    if((x_code_circle + y_code_circle) > 6*6 && (x_code_circle + y_code_circle)<= 8*8 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour4;end
                    if((x_code_circle + y_code_circle) > 6*6 && (x_code_circle + y_code_circle)<= 8*8 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour4;end
                    if((x_code_circle + y_code_circle) > 8*8 && (x_code_circle + y_code_circle)<= 10*10 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour5;end      
                    if((x_code_circle + y_code_circle) > 10*10 && (x_code_circle + y_code_circle)<= 12*12 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour6;end    
                    if((x_code_circle + y_code_circle) > 12*12 && (x_code_circle + y_code_circle)<= 14*14 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour7;end   
                    if((x_code_circle + y_code_circle) > 14*14 && (x_code_circle + y_code_circle)<= 16*16 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour7;end     
                    if((x_code_circle + y_code_circle) > 16*16 && (x_code_circle + y_code_circle)<= 18*18 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour8;end  
                    if((x_code_circle + y_code_circle) > 18*18 && (x_code_circle + y_code_circle)<= 20*20 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour9;end           
                    if((x_code_circle + y_code_circle) > 20*20 && (x_code_circle + y_code_circle)<= 22*22 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour10;end        
                    if((x_code_circle + y_code_circle) > 22*22 && (x_code_circle + y_code_circle)<= 24*24 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour11;end   
                    if((x_code_circle + y_code_circle) > 24*24 && (x_code_circle + y_code_circle)<= 26*26 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour12;end     
                    if((x_code_circle + y_code_circle) > 26*26 && (x_code_circle + y_code_circle)<= 28*28 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour13;end      
                    if((x_code_circle + y_code_circle) > 28*28 && (x_code_circle + y_code_circle)<= 30*30 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour14;end   
                    if((x_code_circle + y_code_circle) > 30*30 && (x_code_circle + y_code_circle)<= 32*32 && x_code_colour!=47 && y_code_colour!=31)begin
                        oled_data_colour = colour15;end         
                end   
   
            end // end of circle therme
            
            /////////////////////////////////////////////////////////////for border selection, border ==0 means no border, border ==1 means thin border and border ==2 means thick border.
            if(state_colour != 0 && stage==0)begin //white border
                if((x_code_colour==0 | x_code_colour==95 | y_code_colour==0 | y_code_colour==63) && border==1) begin
                    oled_data_colour = 16'b11111_111111_11111;
                end
                
                else if((x_code_colour<3 | x_code_colour>92 | y_code_colour<3 | y_code_colour>60) && border==2) begin
                    oled_data_colour = 16'b11111_111111_11111;
                end
                
                else if((x_code_colour<3 | x_code_colour>92 | y_code_colour<3 | y_code_colour>60) && border==0) begin 
                    oled_data_colour = 16'b00000_000000_00000; 
                end      
            end //end of white border
    
            if(state_colour != 0 && stage==1)begin //green border
                if((x_code_colour==0 | x_code_colour==95 | y_code_colour==0 | y_code_colour==63) && border==1) begin
                    oled_data_colour = 16'b00000_111111_00000;
                end
                
                else if((x_code_colour<3 | x_code_colour>92 | y_code_colour<3 | y_code_colour>60) && border==2) begin
                    oled_data_colour = 16'b00000_111111_00000;
                end
                
                else if((x_code_colour<3 | x_code_colour>92 | y_code_colour<3 | y_code_colour>60) && border==0) begin 
                    oled_data_colour = 16'b00000_000000_00000; 
                end
            end //end of green border
    
            if(state_colour != 0 && stage==2)begin //cyan border
                if((x_code_colour==0 | x_code_colour==95 | y_code_colour==0 | y_code_colour==63) && border==1) begin
                    oled_data_colour = 16'b00000_111111_11111;
                end
                
                else if((x_code_colour<3 | x_code_colour>92 | y_code_colour<3 | y_code_colour>60) && border==2) begin
                    oled_data_colour = 16'b00000_111111_11111;
                end
                
                else if((x_code_colour<3 | x_code_colour>92 | y_code_colour<3 | y_code_colour>60) && border==0) begin 
                    oled_data_colour = 16'b00000_000000_00000; 
                end
            end //end of cyan border

            ///////////////////////////////////////////////////////////////////////////////hidding or showing volume bars
            if(sw[12]==1)begin // switch 12 that hides volume bars is switched on
                if(((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 3 && y_code_colour<= 60)) && (stage==0 || stage==1)) begin
                    oled_data_colour = 16'b00000_000000_00000;
                end
                
                else if(((x_code_colour>37 && x_code_colour<57) && (y_code_colour>= 3 && y_code_colour<= 60)) && (stage==2)) begin
                    oled_data_colour = 16'b11111_111111_11111;
                end
                else if(stage==3)begin
                    oled_data_colour = white; 
                    if(x_code_colour==47||y_code_colour==31)begin oled_data_colour = black;end
                    if(((x_code_colour-47)*(x_code_colour-47) + (y_code_colour-31)*(y_code_colour-31)<= 2*2) && x_code_colour!=47 && y_code_colour!=31)begin
                    oled_data_colour = colour1;end
                end            
            end
            
            state_colour_temp <= state_colour; // to store the state_colour used in taking a "screenshot"
            
        end // end of game_mode==0 (flappy bird game not triggered)
       
        ////////////////////////////////////////////////////////////////////////////////////////////////////////// flappy bird game
        
        if(game_mode==1)begin // flappy bird game begins
            death = 0; 
            if(death==0)begin // game ongoing (not game over yet)
                if(state1 == 1) begin y_reference=y_up0; bird_top = 7'd45; bird_bottom = 7'd58; end 
                if(state1 == 2) begin y_reference=y_up1; bird_top = 7'd41; bird_bottom = 7'd54; end 
                if(state1 == 3) begin y_reference=y_up2; bird_top = 7'd37; bird_bottom = 7'd50; end 
                if(state1 == 4) begin y_reference=y_up3; bird_top = 7'd33; bird_bottom = 7'd46; end 
                if(state1 == 5) begin y_reference=y_up4; bird_top = 7'd29; bird_bottom = 7'd42; end 
                if(state1 == 6) begin y_reference=y_up5; bird_top = 7'd25; bird_bottom = 7'd38; end 
                if(state1 == 7) begin y_reference=y_up6; bird_top = 7'd22; bird_bottom = 7'd35; end 
                if(state1 == 8) begin y_reference=y_up7; bird_top = 7'd19; bird_bottom = 7'd32; end 
                if(state1 == 9) begin y_reference=y_up8; bird_top = 7'd16; bird_bottom = 7'd29; end 
                if(state1 == 10 || state1 == 11) begin y_reference=y_up9; bird_top = 7'd13; bird_bottom = 7'd26; end 
                if(state1 == 12 || state1 == 13 ) begin y_reference=y_up10; bird_top = 7'd10; bird_bottom = 7'd23; end 
                if(state1 == 14 || state1 == 15 ) begin y_reference=y_up11; bird_top = 7'd8; bird_bottom = 7'd21; end 
                if(state1 == 16 ) begin y_reference=y_up12; bird_top = 7'd5; bird_bottom = 7'd18; end                
                        
                if(frame_begin_colour) begin x_reference <= x_reference +1;end
                
                if(x_reference==95) begin pipe<= pipe+1; x_reference <=0;end
                if(pipe==3)begin pipe = 0;end
                
                ////////////////////////// start of bird display
                /////////////////// ////// black outline
                if((x_code_colour>=21 && x_code_colour<=27) && ((y_code_colour+y_reference)==61))begin
                    oled_data_colour=black;end   
                else if((x_code_colour>=21 && x_code_colour<=27) && ((y_code_colour+y_reference)==59))begin
                    oled_data_colour=black;end   
                else if((x_code_colour>=21 && x_code_colour<=27) && ((y_code_colour+y_reference)==55))begin
                    oled_data_colour=black;end   
                else if((x_code_colour==27) && ((y_code_colour+y_reference)==56))begin
                    oled_data_colour=black;end   
                else if((x_code_colour==28) && ((y_code_colour+y_reference)==57))begin
                    oled_data_colour=black;end     
                else if((x_code_colour==27) && ((y_code_colour+y_reference)>=59 && (y_code_colour+y_reference)<=60))begin
                    oled_data_colour=black;end      
                else if((x_code_colour==20) && ((y_code_colour+y_reference)>=59 && (y_code_colour+y_reference)<=60))begin
                    oled_data_colour=black;end   
                else if((x_code_colour==20) && (y_code_colour+y_reference)==57)begin
                    oled_data_colour=black;end        
                else if((x_code_colour==19) && ((y_code_colour+y_reference)==58))begin
                    oled_data_colour=black;end
                else if((x_code_colour>=17 && x_code_colour<=20) && ((y_code_colour+y_reference)==62))begin
                    oled_data_colour=black;end                 
                else if((x_code_colour>=14 && x_code_colour<=16) && ((y_code_colour+y_reference)==61))begin
                    oled_data_colour=black;end 
                else if((x_code_colour==14) && ((y_code_colour+y_reference)==60))begin
                    oled_data_colour=black;end                         
                else if((x_code_colour>=11 && x_code_colour<=14) && ((y_code_colour+y_reference)==59))begin
                    oled_data_colour=black;end                         
                else if((x_code_colour==10) && ((y_code_colour+y_reference)==58))begin
                    oled_data_colour=black;end                          
                else if((x_code_colour==9) && ((y_code_colour+y_reference)>=54 && (y_code_colour+y_reference)<=57))begin
                    oled_data_colour=black;end                         
                else if((x_code_colour>=10 && x_code_colour<=15) && (y_code_colour+y_reference)==53)begin
                    oled_data_colour=black;end                         
                else if((x_code_colour==16) && ((y_code_colour+y_reference)==54))begin
                    oled_data_colour=black;end                          
                else if((x_code_colour==17) && ((y_code_colour+y_reference)>=55 && (y_code_colour+y_reference)<=57))begin
                    oled_data_colour=black;end                         
                else if((x_code_colour==15) && (y_code_colour+y_reference)==58)begin
                    oled_data_colour=black;end                                        
                else if((x_code_colour==14) && ((y_code_colour+y_reference)>=51 && (y_code_colour+y_reference)<=52))begin
                    oled_data_colour=black;end                        
                else if((x_code_colour>=15 && x_code_colour<=17) && (y_code_colour+y_reference)==50)begin
                    oled_data_colour=black;end                
                else if((x_code_colour>=17 && x_code_colour<=23) && (y_code_colour+y_reference)==49)begin
                    oled_data_colour=black;end
                else if((x_code_colour==21) && ((y_code_colour+y_reference)==54))begin
                    oled_data_colour=black;end  
                else if((x_code_colour==21) && ((y_code_colour+y_reference)==50))begin
                    oled_data_colour=black;end                                  
                else if((x_code_colour==24) && ((y_code_colour+y_reference)==50))begin
                    oled_data_colour=black;end    
                else if((x_code_colour==23) && ((y_code_colour+y_reference)>=51 && (y_code_colour+y_reference)<=52))begin
                    oled_data_colour=black;end                                           
                else if((x_code_colour==20) && ((y_code_colour+y_reference)>=51 && (y_code_colour+y_reference)<=53))begin
                    oled_data_colour=black;end                                        
                else if((x_code_colour==25) && ((y_code_colour+y_reference)>=51 && (y_code_colour+y_reference)<=54))begin
                    oled_data_colour=black;end      
                else if((x_code_colour>=21 && x_code_colour<=26) && (y_code_colour+y_reference)==58)begin
                    oled_data_colour=black;end //the line for mouth
                                                                                                                  
                ///////////////orange beak////////////////
                else if((x_code_colour>=21 && x_code_colour<=26) && ((y_code_colour+y_reference)==56))begin
                    oled_data_colour=orange;end 
                else if((x_code_colour>=21 && x_code_colour<=27) && ((y_code_colour+y_reference)==57))begin
                    oled_data_colour=orange;end 
                else if((x_code_colour>=21 && x_code_colour<=26) && ((y_code_colour+y_reference)==59))begin
                    oled_data_colour=orange;end 
                else if((x_code_colour>=21 && x_code_colour<=26) && ((y_code_colour+y_reference)==60))begin
                    oled_data_colour=orange;end 
                else if((x_code_colour==20) && ((y_code_colour+y_reference)==58))begin
                    oled_data_colour=orange;end   
                        
                ///////////////dark yellow/////////////////////////
                else if((x_code_colour>=15 && x_code_colour<=19) && ((y_code_colour+y_reference)>=59 && (y_code_colour+y_reference)<=60))begin
                    oled_data_colour=dark_yellow;end 
                else if((x_code_colour>=17 && x_code_colour<=20) && (y_code_colour+y_reference)==61)begin
                    oled_data_colour=dark_yellow;end
                                                 
                ///////////////white yellow/////////////////////////                        
                else if((x_code_colour>=10 && x_code_colour<=15) && ((y_code_colour+y_reference)>=54 && (y_code_colour+y_reference)<=55))begin
                    oled_data_colour=white_yellow;end                         
                else if((x_code_colour==16) && ((y_code_colour+y_reference)>=55 && (y_code_colour+y_reference)<=56))begin
                    oled_data_colour=white_yellow;end               
                else if((x_code_colour==12) && ((y_code_colour+y_reference)>=56 && (y_code_colour+y_reference)<=57))begin
                    oled_data_colour=white_yellow;end                        
                else if((x_code_colour==13) && ((y_code_colour+y_reference)==57))begin
                    oled_data_colour=white_yellow;end  
                    
                ///////////////////////just yellow////////////////////
                else if((x_code_colour>=18 && x_code_colour<=20) && ((y_code_colour+y_reference)==50))begin
                    oled_data_colour=yellow;end
                else if((x_code_colour>=15 && x_code_colour<=19) && ((y_code_colour+y_reference)>=51 && (y_code_colour+y_reference)<=52))begin
                    oled_data_colour=yellow;end
                else if((x_code_colour>=16 && x_code_colour<=19) && ((y_code_colour+y_reference)==53))begin
                    oled_data_colour=yellow;end
                else if((x_code_colour>=17 && x_code_colour<=20) && ((y_code_colour+y_reference)==54))begin
                    oled_data_colour=yellow;end
                else if((x_code_colour>=18 && x_code_colour<=20) && ((y_code_colour+y_reference)==55))begin
                    oled_data_colour=yellow;end
                else if((x_code_colour>=18 && x_code_colour<=20) && ((y_code_colour+y_reference)==56))begin
                    oled_data_colour=yellow;end
                else if((x_code_colour>=18 && x_code_colour<=19) && ((y_code_colour+y_reference)==57))begin
                    oled_data_colour=yellow;end
                else if((x_code_colour>=16 && x_code_colour<=18) && ((y_code_colour+y_reference)==58))begin
                    oled_data_colour=yellow;end                        
                else if((x_code_colour>=10 && x_code_colour<=11) && ((y_code_colour+y_reference)==56))begin
                    oled_data_colour=yellow;end                        
                else if((x_code_colour>=13 && x_code_colour<=15) && ((y_code_colour+y_reference)==56))begin
                    oled_data_colour=yellow;end                        
                else if((x_code_colour>=10 && x_code_colour<=11) && ((y_code_colour+y_reference)==57))begin
                    oled_data_colour=yellow;end                        
                else if((x_code_colour>=14 && x_code_colour<=16) && ((y_code_colour+y_reference)==57))begin
                    oled_data_colour=yellow;end             
                else if((x_code_colour>=11 && x_code_colour<=14) && ((y_code_colour+y_reference)==58))begin
                    oled_data_colour=yellow;end      
                               
                else begin 
                    oled_data_colour=white;
                end  
                //////////////////end of bird display, start of pipes//////////////////////////////////////
       
                if(pipe==0)begin //pipes no.1 (gap in the middle)
                    pipe_top= 7'd26; pipe_bottom= 7'd47;
                    //bottom part
                    if(((x_code_colour+x_reference)>=83 && (x_code_colour+x_reference)<=94) && (y_code_colour>=48 && y_code_colour<=50))begin
                        oled_data_colour=green;end                
                    else if(((x_code_colour+x_reference)>=85 && (x_code_colour+x_reference)<=92) && (y_code_colour>=52 && y_code_colour<=63))begin
                        oled_data_colour=green;end                 
                    else if(((x_code_colour+x_reference)>=82 && (x_code_colour+x_reference)<=95) && (y_code_colour==47))begin
                        oled_data_colour=black;end                
                    else if(((x_code_colour+x_reference)>=82 && (x_code_colour+x_reference)<=95) && (y_code_colour==51))begin
                        oled_data_colour=black;end                 
                    else if(((x_code_colour+x_reference)==82) && (y_code_colour>=48 && y_code_colour<=50))begin
                        oled_data_colour=black;end                
                    else if(((x_code_colour+x_reference)==95) && (y_code_colour>=48 && y_code_colour<=50))begin
                        oled_data_colour=black;end                
                    else if(((x_code_colour+x_reference)==84) && (y_code_colour>=52 && y_code_colour<=63))begin
                        oled_data_colour=green;end                
                    else if(((x_code_colour+x_reference)==93) && (y_code_colour>=52 && y_code_colour<=63))begin
                        oled_data_colour=green;end                 
                    
                    //top part
                    else if(((x_code_colour+x_reference)>=83 && (x_code_colour+x_reference)<=94) && (y_code_colour>=23 && y_code_colour<=25))begin
                        oled_data_colour=green;end                
                    else if(((x_code_colour+x_reference)>=84 && (x_code_colour+x_reference)<=93) && (y_code_colour>=0 && y_code_colour<=21))begin
                        oled_data_colour=green;end                 
                    else if(((x_code_colour+x_reference)>=82 && (x_code_colour+x_reference)<=95) && (y_code_colour==22))begin
                        oled_data_colour=black;end                
                    else if(((x_code_colour+x_reference)>=82 && (x_code_colour+x_reference)<=95) && (y_code_colour==26))begin
                        oled_data_colour=black;end                 
                    else if(((x_code_colour+x_reference)==82) && (y_code_colour>=23 && y_code_colour<=25))begin
                        oled_data_colour=black;end                
                    else if(((x_code_colour+x_reference)==95) && (y_code_colour>=23 && y_code_colour<=25))begin
                        oled_data_colour=black;end                
                    else if(((x_code_colour+x_reference)==84) && (y_code_colour>=1 && y_code_colour<=20))begin
                        oled_data_colour=green;end                
                    else if(((x_code_colour+x_reference)==93) && (y_code_colour>=1 && y_code_colour<=20))begin
                        oled_data_colour=green;end        
                                   
                end //end of pipe no.1
                          
                if(pipe==1)begin //pipes no.2 (gap at the bottom)               
                    pipe_top= 7'd26; pipe_bottom= 7'd55;
                    //bottom part
                    if(((x_code_colour+x_reference)>=83 && (x_code_colour+x_reference)<=94) && (y_code_colour>=56 && y_code_colour<=58))begin
                        oled_data_colour=green;end                
                    else if(((x_code_colour+x_reference)>=85 && (x_code_colour+x_reference)<=92) && (y_code_colour>=60 && y_code_colour<=63))begin
                        oled_data_colour=green;end                 
                    else if(((x_code_colour+x_reference)>=82 && (x_code_colour+x_reference)<=95) && (y_code_colour==55))begin
                        oled_data_colour=black;end                
                    else if(((x_code_colour+x_reference)>=82 && (x_code_colour+x_reference)<=95) && (y_code_colour==59))begin
                        oled_data_colour=black;end                 
                    else if(((x_code_colour+x_reference)==82) && (y_code_colour>=56 && y_code_colour<=58))begin
                        oled_data_colour=black;end                
                    else if(((x_code_colour+x_reference)==95) && (y_code_colour>=56 && y_code_colour<=58))begin
                        oled_data_colour=black;end                
                    else if(((x_code_colour+x_reference)==84) && (y_code_colour>=60 && y_code_colour<=63))begin
                        oled_data_colour=green;end                
                    else if(((x_code_colour+x_reference)==93) && (y_code_colour>=60 && y_code_colour<=63))begin
                        oled_data_colour=green;end                 
                    
                    //top part
                    else if(((x_code_colour+x_reference)>=83 && (x_code_colour+x_reference)<=94) && (y_code_colour>=23 && y_code_colour<=25))begin
                        oled_data_colour=green;end                
                    else if(((x_code_colour+x_reference)>=84 && (x_code_colour+x_reference)<=93) && (y_code_colour>=0 && y_code_colour<=21))begin
                        oled_data_colour=green;end                 
                    else if(((x_code_colour+x_reference)>=82 && (x_code_colour+x_reference)<=95) && (y_code_colour==22))begin
                        oled_data_colour=black;end                
                    else if(((x_code_colour+x_reference)>=82 && (x_code_colour+x_reference)<=95) && (y_code_colour==26))begin
                        oled_data_colour=black;end                 
                    else if(((x_code_colour+x_reference)==82) && (y_code_colour>=23 && y_code_colour<=25))begin
                        oled_data_colour=black;end                
                    else if(((x_code_colour+x_reference)==95) && (y_code_colour>=23 && y_code_colour<=25))begin
                        oled_data_colour=black;end                
                    else if(((x_code_colour+x_reference)==84) && (y_code_colour>=1 && y_code_colour<=20))begin
                        oled_data_colour=green;end                
                    else if(((x_code_colour+x_reference)==93) && (y_code_colour>=1 && y_code_colour<=20))begin
                        oled_data_colour=green;end     
                                      
                end //end for pipe no.2
                      
                if(pipe==2)begin //pipe no.3 (gap very wide - easiest)                
                    pipe_top= 7'd11; pipe_bottom= 7'd55;
                    //bottom part
                    if(((x_code_colour+x_reference)>=83 && (x_code_colour+x_reference)<=94) && (y_code_colour>=56 && y_code_colour<=58))begin
                        oled_data_colour=green;end                
                    else if(((x_code_colour+x_reference)>=85 && (x_code_colour+x_reference)<=92) && (y_code_colour>=60 && y_code_colour<=63))begin
                        oled_data_colour=green;end                 
                    else if(((x_code_colour+x_reference)>=82 && (x_code_colour+x_reference)<=95) && (y_code_colour==55))begin
                        oled_data_colour=black;end                
                    else if(((x_code_colour+x_reference)>=82 && (x_code_colour+x_reference)<=95) && (y_code_colour==59))begin
                        oled_data_colour=black;end                 
                    else if(((x_code_colour+x_reference)==82) && (y_code_colour>=56 && y_code_colour<=58))begin
                        oled_data_colour=black;end                
                    else if(((x_code_colour+x_reference)==95) && (y_code_colour>=56 && y_code_colour<=58))begin
                        oled_data_colour=black;end                
                    else if(((x_code_colour+x_reference)==84) && (y_code_colour>=60 && y_code_colour<=63))begin
                        oled_data_colour=green;end                
                    else if(((x_code_colour+x_reference)==93) && (y_code_colour>=60 && y_code_colour<=63))begin
                        oled_data_colour=green;end                 
                    
                    //top part
                    else if(((x_code_colour+x_reference)>=83 && (x_code_colour+x_reference)<=94) && (y_code_colour>=8 && y_code_colour<=10))begin
                        oled_data_colour=green;end                
                    else if(((x_code_colour+x_reference)>=84 && (x_code_colour+x_reference)<=93) && (y_code_colour>=0 && y_code_colour<=6))begin
                        oled_data_colour=green;end                 
                    else if(((x_code_colour+x_reference)>=82 && (x_code_colour+x_reference)<=95) && (y_code_colour==7))begin
                        oled_data_colour=black;end                
                    else if(((x_code_colour+x_reference)>=82 && (x_code_colour+x_reference)<=95) && (y_code_colour==11))begin
                        oled_data_colour=black;end                 
                    else if(((x_code_colour+x_reference)==82) && (y_code_colour>=23 && y_code_colour<=10))begin
                        oled_data_colour=black;end                
                    else if(((x_code_colour+x_reference)==95) && (y_code_colour>=23 && y_code_colour<=10))begin
                        oled_data_colour=black;end                
                    else if(((x_code_colour+x_reference)==84) && (y_code_colour>=1 && y_code_colour<=5))begin
                        oled_data_colour=green;end                
                    else if(((x_code_colour+x_reference)==93) && (y_code_colour>=1 && y_code_colour<=5))begin
                        oled_data_colour=green;end     
                                      
                end //end of pipe no.3                        
                                               
                if(pipe==3)begin //pipe no.4 (gap at the top)    
                    pipe_top= 7'd9; pipe_bottom= 7'd45;                                        
                    //bottom part
                    if(((x_code_colour+x_reference)>=83 && (x_code_colour+x_reference)<=94) && (y_code_colour>=46 && y_code_colour<=48))begin
                        oled_data_colour=green;end                
                    else if(((x_code_colour+x_reference)>=85 && (x_code_colour+x_reference)<=92) && (y_code_colour>=50 && y_code_colour<=63))begin
                        oled_data_colour=green;end                 
                    else if(((x_code_colour+x_reference)>=82 && (x_code_colour+x_reference)<=95) && (y_code_colour==45))begin
                        oled_data_colour=black;end                
                    else if(((x_code_colour+x_reference)>=82 && (x_code_colour+x_reference)<=95) && (y_code_colour==49))begin
                        oled_data_colour=black;end                 
                    else if(((x_code_colour+x_reference)==82) && (y_code_colour>=46 && y_code_colour<=48))begin
                        oled_data_colour=black;end                
                    else if(((x_code_colour+x_reference)==95) && (y_code_colour>=46 && y_code_colour<=48))begin
                        oled_data_colour=black;end                
                    else if(((x_code_colour+x_reference)==85) && (y_code_colour>=50 && y_code_colour<=61))begin
                        oled_data_colour=green;end                
                    else if(((x_code_colour+x_reference)==92) && (y_code_colour>=50 && y_code_colour<=61))begin
                        oled_data_colour=green;end                 
                    
                    //top part
                    else if(((x_code_colour+x_reference)>=83 && (x_code_colour+x_reference)<=94) && (y_code_colour>=6 && y_code_colour<=8))begin
                        oled_data_colour=green;end                
                    else if(((x_code_colour+x_reference)>=84 && (x_code_colour+x_reference)<=93) && (y_code_colour>=0 && y_code_colour<=4))begin
                        oled_data_colour=green;end                 
                    else if(((x_code_colour+x_reference)>=82 && (x_code_colour+x_reference)<=95) && (y_code_colour==5))begin
                        oled_data_colour=black;end                
                    else if(((x_code_colour+x_reference)>=82 && (x_code_colour+x_reference)<=95) && (y_code_colour==9))begin
                        oled_data_colour=black;end                 
                    else if(((x_code_colour+x_reference)==82) && (y_code_colour>=23 && y_code_colour<=8))begin
                        oled_data_colour=black;end                
                    else if(((x_code_colour+x_reference)==95) && (y_code_colour>=23 && y_code_colour<=8))begin
                        oled_data_colour=black;end                
                    else if(((x_code_colour+x_reference)==84) && (y_code_colour>=1 && y_code_colour<=3))begin
                        oled_data_colour=green;end                
                    else if(((x_code_colour+x_reference)==93) && (y_code_colour>=1 && y_code_colour<=3))begin
                        oled_data_colour=green;end             
   
                end //end of pipe no.4
      
            end // end of if death = 0
                    
            if(bird_top <= pipe_top && (x_reference >= 55 && x_reference<=68)) begin // conditions for bird to die (game over)
                death = 1; 
            end
            
            if(bird_bottom >= pipe_bottom && (x_reference >= 55 && x_reference<=68)) begin // conditions for bird to die (game over)
                death = 1; 
            end
        
            if(death==1) begin // if game over, reset game and go back to game_mode = 0
                x_reference = 0;
                death = 0;
                game_mode=0;
            end
    
        end // end of stage1 = 2 (unlocked stage)
  
    end // end of always 

endmodule

