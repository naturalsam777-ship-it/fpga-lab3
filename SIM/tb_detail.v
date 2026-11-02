`timescale 1ns/1ns
module tb_detail;
 reg sys_clk=0,sys_rst_n=0;wire hsync,vsync;wire [15:0] rgb;
 must_vga dut(sys_clk,sys_rst_n,hsync,vsync,rgb);
 always #10 sys_clk=~sys_clk;
 initial begin
  #100;sys_rst_n=1;
  #24587417;sys_rst_n=0;#20000003;sys_rst_n=1;
 end
 initial begin
  $dumpfile("evidence/detail.vcd");
  $dumpvars(0,sys_clk,sys_rst_n,dut.vga_clk,hsync,vsync,rgb,
   dut.u_ctrl.cnt_h,dut.u_ctrl.cnt_v,dut.u_ctrl.rgb_valid,
   dut.u_ctrl.pix_data_req,dut.pix_x,dut.pix_y,dut.pix_data);
  #500;$dumpoff;
  #1119400;$dumpon;#33000;$dumpoff;
  #6623000;$dumpon;#33000;$dumpoff;
  #8639000;$dumpon;#33000;$dumpoff;
  #8106500;$dumpon;#1000;$dumpoff;
  #19999000;$dumpon;#1000;$dumpoff;
  $finish;
 end
endmodule
