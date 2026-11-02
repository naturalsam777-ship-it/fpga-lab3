`timescale 1ns/1ns
module must_vga(
    input wire sys_clk, sys_rst_n,
    output wire hsync, vsync,
    output wire [15:0] rgb
);
    wire vga_clk;
    wire [9:0] pix_x, pix_y;
    wire [15:0] pix_data;
    pixel_clock u_clock(.sys_clk(sys_clk), .vga_clk(vga_clk));
    vga_ctrl u_ctrl(.vga_clk(vga_clk), .sys_rst_n(sys_rst_n),
        .pix_data(pix_data), .pix_x(pix_x), .pix_y(pix_y),
        .hsync(hsync), .vsync(vsync), .rgb(rgb));
    vga_pic u_pic(.vga_clk(vga_clk), .sys_rst_n(sys_rst_n),
        .pix_x(pix_x), .pix_y(pix_y), .pix_data(pix_data));
endmodule
