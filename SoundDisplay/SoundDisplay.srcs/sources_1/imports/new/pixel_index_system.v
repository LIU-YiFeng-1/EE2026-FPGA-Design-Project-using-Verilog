`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/19/2020 10:38:44 AM
// Design Name: 
// Module Name: pixel_index_system
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


module pixel_index_system(
    input [12:0] pixel_coordinate,
    output [6:0] X_val,
    output [5:0] Y_val,
    output [11:0] X_circle_val,
    output [11:0] Y_circle_val
    );
    
    assign X_val = pixel_coordinate % 96;
    assign Y_val = pixel_coordinate / 96;
    assign X_circle_val = ((pixel_coordinate % 96)-47) * ((pixel_coordinate % 96)-47);
    assign Y_circle_val = ((pixel_coordinate / 96)-31) * ((pixel_coordinate / 96)-31);
endmodule
