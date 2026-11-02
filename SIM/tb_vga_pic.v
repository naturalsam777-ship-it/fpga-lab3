`timescale 1ns/1ns
module tb_vga_pic;
 reg clk=0,rst=0;reg [9:0] x=1023,y=1023;wire [15:0] color;
 reg [15:0] reference[0:307199];integer i;
 vga_pic dut(clk,rst,x,y,color);
 always #20 clk=~clk;
 initial begin
  $readmemh("sim/expected_frame.hex",reference);
  #1;rst=1;
  for(i=0;i<307200;i=i+1) begin
   @(negedge clk);x=i%640;y=i/640;
   @(posedge clk);#1;
   if(color!==reference[i]) $fatal(1,"pixel %0d mismatch",i);
  end
  @(negedge clk);x=144;y=208;@(posedge clk);#1;
  if(color!==16'hffff) $fatal(1,"M probe");
  #7;rst=0;#1;if(color!==0) $fatal(1,"async clear");
  #2;rst=1;@(posedge clk);#1;
  if(color!==16'hffff) $fatal(1,"recovery");
  @(negedge clk);x=1023;y=1023;@(posedge clk);#1;
  if(color!==0) $fatal(1,"outside screen");
  $display("PASS pixel: 307200 expected pixels; async clear; recovery; sentinel");$finish;
 end
endmodule
