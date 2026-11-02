`timescale 1ns/1ns
module tb_pixel_clock;
 reg sys_clk=0; wire vga_clk; integer i; time last_edge;
 pixel_clock dut(sys_clk,vga_clk);
 always #10 sys_clk=~sys_clk;
 initial begin
  $dumpfile("evidence/clock.vcd"); $dumpvars(0,tb_pixel_clock);
  @(posedge vga_clk);last_edge=$time;
  for(i=0;i<100;i=i+1) begin
   @(posedge vga_clk);
   if($time-last_edge!=40) $fatal(1,"pixel period");
   last_edge=$time;
   @(negedge vga_clk);
   if($time-last_edge!=20) $fatal(1,"pixel high width");
  end
  $display("PASS clock: 100 periods=40 ns; high width=20 ns");$finish;
 end
endmodule
