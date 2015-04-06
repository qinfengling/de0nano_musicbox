`timescale 1ns/10ps
module musicboxtb;

  initial begin
     $dumpfile("musicboxtb.vcd");
     $dumpvars(0,musicboxtb);
     # 8000000 $finish;
  end

  /* Make a regular pulsing clock. */
  reg clk = 0;
  always #20 clk = !clk;

  wire speaker;
  wire led;
  musicbox mb (clk, speaker, led);

  initial
     $monitor("At time %t, speaker = %h (%0d), led = %h (%0d)",
              $time, speaker, speaker, led, led);
endmodule
