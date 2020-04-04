`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.03.2020 14:47:28
// Design Name: 
// Module Name: clock_divider
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


module clock_divider(
    input clk_in,
    output reg clk_out = 0
    );
    
    reg [11:0] COUNT = 12'd0;
    
    always @ (posedge clk_in)begin 
        COUNT <= (COUNT == 2500)? 0 : COUNT + 1;
        clk_out <= ( COUNT == 2500 ) ? ~clk_out : clk_out; 
    end
        
endmodule
