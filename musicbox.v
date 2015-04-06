/*
 * A musicbox module / template for the DE0-Nano board
 * Origin website:http://www.fpga4fun.com/MusicBox1.html
 */

`define COUNTER_SIZE 32
`define CONST_50M    50000000 // 50M
`define NOTE_HZ      1

module musicbox(
  //////////// CLOCK //////////
  input 		          		CLOCK_50,
  //////////// SPEAKER //////////
  output		          		SPEAKER,
  //////////// Indicator //////////
  output                                        LED
);
  parameter clkdivider = `CONST_50M/`NOTE_HZ/2;

  /*
  Register instantiation
  */
  reg  [`COUNTER_SIZE-1:0] counter;
  reg speaker;
  reg led;

  assign SPEAKER = speaker;
  assign LED = led;

  always @(posedge CLOCK_50) if (counter == 0) counter <= clkdivider - 1; else counter <= counter - 1;
  always @(posedge CLOCK_50) if (counter == 0) speaker <= ~speaker; 
  always @(posedge CLOCK_50) if (counter == 0) led <= ~led;
endmodule
