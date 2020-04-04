`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2020 10:32:34 AM
// Design Name: 
// Module Name: clk6p25m
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


module clock_switch(
    input CLOCK,
    output reg New_CLOCK
    );
    
    reg [3:0] counter;
    
    always @(posedge CLOCK)begin
        counter <= counter + 1;
        New_CLOCK <= (counter==4'b0)? ~New_CLOCK : New_CLOCK;
    end
    
endmodule
