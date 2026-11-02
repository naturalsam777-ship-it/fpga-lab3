`timescale 1ns/1ns
module tb_vga_ctrl;
 reg clk=0,rst=0; reg [15:0] color=16'h1234;
 wire [9:0] x,y;wire hs,vs;wire [15:0] rgb;
 integer k,h,v,valid_count=0,request_count=0;
 vga_ctrl dut(clk,rst,color,x,y,hs,vs,rgb);
 always #20 clk=~clk;
 initial begin
  #1;rst=1;
  for(k=1;k<=420000;k=k+1) begin
   @(posedge clk);#1;h=k%800;v=(k/800)%525;
   if(dut.cnt_h!==h || dut.cnt_v!==v) $fatal(1,"scan counters");
   if(hs!==(h<96) || vs!==(v<2)) $fatal(1,"sync pulse");
   if(h>=144 && h<784 && v>=35 && v<515) begin
    valid_count=valid_count+1;
    if(rgb!==16'h1234) $fatal(1,"valid gate");
   end else if(rgb!==0) $fatal(1,"blanking");
   if(h>=143 && h<783 && v>=35 && v<515) begin
    request_count=request_count+1;
    if(x!==h-143 || y!==v-35) $fatal(1,"request coordinates");
   end else if(x!==1023 || y!==1023) $fatal(1,"invalid coordinates");
  end
  if(valid_count!=307200 || request_count!=307200) $fatal(1,"window size");
  #7;rst=0;#1;if(rgb!==0) $fatal(1,"reset gate");
  $display("PASS timing: 420000 cycles; valid=307200; request=307200; coordinates 0..639,0..479");$finish;
 end
endmodule
