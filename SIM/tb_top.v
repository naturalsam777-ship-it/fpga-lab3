`timescale 1ns/1ns
module tb_top;
 reg sys_clk=0,sys_rst_n=0;wire hsync,vsync;wire [15:0] rgb;
 must_vga dut(sys_clk,sys_rst_n,hsync,vsync,rgb);
 always #10 sys_clk=~sys_clk;
 reg [15:0] reference[0:307199];reg [15:0] want;
 integer k,h,v,x,y,checks=0,fd,white_count=0;
 time last_h=0,last_v=0,h_rise=0,v_rise=0;
 integer h_periods=0,v_periods=0;
 initial begin
  $dumpfile("evidence/sync.vcd");$dumpvars(0,sys_rst_n,hsync,vsync);
  $readmemh("sim/expected_frame.hex",reference);
  fd=$fopen("evidence/actual_frame.hex","w");
  #100;sys_rst_n=1;
  #24587417;
  if(rgb!==16'hffff) $fatal(1,"reset stimulus must interrupt a white stroke");
  sys_rst_n=0;#1;
  if(rgb!==0) $fatal(1,"reset must blank immediately");
  #20000002;sys_rst_n=1;
 end
 always @(posedge hsync) if($time>0) begin
  if(last_h!=0) begin
   if($time-last_h!=32000) $fatal(1,"horizontal period");
   h_periods=h_periods+1;
  end
  last_h=$time;h_rise=$time;
 end
 always @(negedge hsync) if(h_rise!=0 && $time-h_rise!=3840) $fatal(1,"horizontal width");
 always @(posedge vsync) if($time>0) begin
  if(last_v!=0) begin
   if($time-last_v!=16800000) $fatal(1,"vertical period");
   v_periods=v_periods+1;
  end
  last_v=$time;v_rise=$time;
 end
 always @(negedge vsync) if(v_rise!=0 && $time-v_rise!=64000) $fatal(1,"vertical width");
 initial begin
  for(k=1;k<=1680000;k=k+1) begin
   @(posedge dut.vga_clk);#1;h=k%800;v=(k/800)%525;
   if(dut.u_ctrl.cnt_h!==h || dut.u_ctrl.cnt_v!==v) $fatal(1,"top counters");
   want=0;
   if(h>=144 && h<784 && v>=35 && v<515) begin
    x=h-144;y=v-35;
    if(sys_rst_n) want=reference[y*640+x];
    if(k<420000) begin
     $fdisplay(fd,"%04h",rgb);
     if(rgb==16'hffff) white_count=white_count+1;
    end
   end
   if(rgb!==want) $fatal(1,"RGB at k=%0d h=%0d v=%0d got=%h expected=%h",k,h,v,rgb,want);
   checks=checks+1;
  end
  $fclose(fd);
  if(h_periods<2000 || v_periods<3) $fatal(1,"insufficient period coverage");
  $display("PASS top: %0d pixel-clock checks; H=32000ns/3840ns; V=16800000ns/64000ns",checks);
  $display("First frame white pixels=%0d; full image captured; reset at24587517ns, release44587520ns",white_count);
  $finish;
 end
endmodule
