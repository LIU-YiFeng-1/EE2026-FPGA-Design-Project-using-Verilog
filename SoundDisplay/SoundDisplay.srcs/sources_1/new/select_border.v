`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2020 11:31:12
// Design Name: 
// Module Name: select_border
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


module select_border(
    input clock,
    input [1:0]sw_border,
    output reg [1:0] state
    );
    
    always @(posedge clock)begin
        if(sw_border[0] && ~sw_border[1]) 
            begin 
            state =1; 
            end
        if(sw_border[1] && ~sw_border[0]) 
            begin 
            state =2; 
            end
        if(~sw_border[0] && ~sw_border[1]) 
            begin 
            state =0; 
            end
    
    end

endmodule
