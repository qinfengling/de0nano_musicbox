/*
 * A musicbox module / template for the DE0-Nano board
 * Origin website:http://www.fpga4fun.com/MusicBox1.html
 */

`define COUNTER_SIZE 32

module music_ROM(
  input clk,
  input [7:0] address,
  output reg [7:0] note
);

always @(posedge clk)
  case(address)
    0, 1: note <= 8'd27; // C C
    2: note <= 8'd29; // D
    3: note <= 8'd27; // C
    4: note <= 8'd32; // F
    5: note <= 8'd31; // E
    6: note <= 8'd0;
    7, 8: note <= 8'd27; // C C
    9: note <= 8'd29; // D
    10: note <= 8'd27; // C
    11: note <= 8'd34; // G
    12: note <= 8'd32; // F
    13: note <= 8'd0;
    14, 15: note <= 8'd27; //C C
    16: note <= 8'd39; // C + 12
    17: note <= 8'd24; // A
    18: note <= 8'd32; // F
    19: note <= 8'd31; // E
    20: note <= 8'd29; // D
    21: note <= 8'd0;
    22, 23: note <= 8'd39; // B B
    24: note <= 8'd24; // A
    25: note <= 8'd32; // F
    26: note <= 8'd34; // G
    27: note <= 8'd32; // F
    default: note <= 8'd0;
  endcase
endmodule

module divide_by12(numer, quotient, remain);
  input [5:0] numer;
  output [2:0] quotient;
  output [3:0] remain;

  reg [2:0] quotient;
  reg [3:0] remain_bit3_bit2;

  assign remain = {remain_bit3_bit2, numer[1:0]}; // the first 2 bits are copied through

  always @(numer[5:2]) // and just do a divide by "3" on the remaining bits
    case(numer[5:2])
      0: begin quotient=0; remain_bit3_bit2=0; end
      1: begin quotient=0; remain_bit3_bit2=1; end
      2: begin quotient=0; remain_bit3_bit2=2; end
      3: begin quotient=1; remain_bit3_bit2=0; end
      4: begin quotient=1; remain_bit3_bit2=1; end
      5: begin quotient=1; remain_bit3_bit2=2; end
      6: begin quotient=2; remain_bit3_bit2=0; end
      7: begin quotient=2; remain_bit3_bit2=1; end
      8: begin quotient=2; remain_bit3_bit2=2; end
      9: begin quotient=3; remain_bit3_bit2=0; end
      10: begin quotient=3; remain_bit3_bit2=1; end
      11: begin quotient=3; remain_bit3_bit2=2; end
      12: begin quotient=4; remain_bit3_bit2=0; end
      13: begin quotient=4; remain_bit3_bit2=1; end
      14: begin quotient=4; remain_bit3_bit2=2; end
      15: begin quotient=5; remain_bit3_bit2=0; end
    endcase
endmodule

module musicbox(
  //////////// CLOCK //////////
  input CLOCK_50,
  //////////// SPEAKER //////////
  output SPEAKER
);

  reg clk;
  always @(posedge CLOCK_50) clk <= ~clk;

  reg  [`COUNTER_SIZE-1:0] tone;
  always @(posedge clk) tone <= tone+1;

  wire [7:0] fullnote;
  music_ROM ROM(.clk(clk), .address(tone[27:23]), .note(fullnote));

  wire [2:0] octave;
  wire [3:0] note;
  divide_by12 divby12(.numer(fullnote[5:0]), .quotient(octave), .remain(note));

  reg [8:0] clk_50divider;
  always @(note)
    case(note)
      0: clk_50divider = 512-1; // A
      1: clk_50divider = 483-1; // A#/Bb
      2: clk_50divider = 456-1; // B
      3: clk_50divider = 431-1; // C
      4: clk_50divider = 406-1; // C#/Db
      5: clk_50divider = 384-1; // D
      6: clk_50divider = 362-1; // D#/Eb
      7: clk_50divider = 342-1; // E
      8: clk_50divider = 323-1; // F
      9: clk_50divider = 304-1; // F#/Gb
      10: clk_50divider = 287-1; // G
      11: clk_50divider = 271-1; // G#/Ab
      default: clk_50divider = 0; // should never happen
    endcase

  reg [8:0] counter_note;
  always @(posedge clk) if (counter_note == 0) counter_note <= clk_50divider; else counter_note <= counter_note - 1;

  reg [7:0] counter_octave;
  always @(posedge clk)
  if (counter_note == 0)
  begin
    if (counter_octave == 0)
      counter_octave <= (octave == 0 ? 255:octave == 1 ? 127:octave == 2 ? 63:octave == 3 ? 31:octave == 4 ? 15:7);
    else
      counter_octave <= counter_octave - 1;
  end

  reg speaker;
  assign SPEAKER = speaker;

  always @(posedge clk) if (fullnote != 0 && counter_note == 0 && counter_octave == 0) speaker <= ~speaker; 
endmodule
