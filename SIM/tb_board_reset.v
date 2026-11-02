`timescale 1ns/1ns
module tb_board_reset;
 reg clk=0, reset=1, B2=1, B3=1, B4=1, B5=1;
 wire h_sync,v_sync; wire [15:0] rgb;
 wire led1,led2,led3,led4,led5;
 DevelopmentBoard dut(.*);
 always #10 clk=~clk;
 integer i,white_before,white_after,white_b3;
 initial begin
  white_before=0; white_after=0; white_b3=0;
  for(i=0;i<840000;i=i+1) begin @(negedge clk); if(rgb==16'hffff) white_before=white_before+1; end
  if(white_before==0) $fatal(1,"No characters before reset");
  wait(rgb==16'hffff); #3; reset=0; #1;
  if(rgb!==0) $fatal(1,"RESET did not blank white pixel immediately");
  for(i=0;i<840000;i=i+1) begin @(negedge clk); if(rgb!==0) $fatal(1,"RESET hold did not stay black"); end
  reset=1;
  for(i=0;i<840000;i=i+1) begin @(negedge clk); if(rgb==16'hffff) white_after=white_after+1; end
  if(white_after==0) $fatal(1,"Characters did not return after RESET release");
  B3=0;
  for(i=0;i<840000;i=i+1) begin @(negedge clk); if(rgb==16'hffff) white_b3=white_b3+1; end
  if(white_b3!=white_after) $fatal(1,"B3 still changes the display");
  $display("PASS: RESET clears immediately and while held; release restores; B3 has no effect. White samples: %0d/%0d/%0d",white_before,white_after,white_b3);
  $finish;
 end
 initial begin #100000000; $fatal(1,"Timeout"); end
endmodule
