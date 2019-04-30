`timescale 1ns / 1ps
`define CLK100_QSIZE 1000
`define CLK200_QSIZE 1000
`define CLK266_QSIZE 1000
`define CLK400_QSIZE 1000

module top(clk_p, clk_n, cpu_reset);
	 
  input clk_p, clk_n, cpu_reset;
  
  wire clk100, clk200, clk266, clk400, locked;
  clock_wiz cw(
    .CLKIN1_N_IN(clk_n), 
    .CLKIN1_P_IN(clk_p), 
    .RST_IN(cpu_reset), 
    .CLKOUT0_OUT(clk100),
    .CLKOUT1_OUT(clk200),
    .CLKOUT2_OUT(clk266), 
    .CLKOUT3_OUT(clk400), 
    .LOCKED_OUT(locked));
	 
  wire output_comb;
  ro_comb rc(.output_comb(output_comb));
  
  reg [`CLK100_QSIZE-1:0] clk100_queue;  
  always @(posedge clk100, posedge cpu_reset) begin
    if (cpu_reset) begin
	   clk100_queue <= 'd0;
	 end else if (locked) begin
	   clk100_queue <= {clk100_queue[`CLK100_QSIZE-2:1], output_comb};
	 end
  end
  
  reg [`CLK200_QSIZE-1:0] clk200_queue;  
  always @(posedge clk200, posedge cpu_reset) begin
    if (cpu_reset) begin
	   clk200_queue <= 'd0;
	 end else if (locked) begin
	   clk200_queue <= {clk200_queue[`CLK200_QSIZE-2:1], output_comb};
	 end
  end
  
  reg [`CLK266_QSIZE-1:0] clk266_queue;  
  always @(posedge clk266, posedge cpu_reset) begin
    if (cpu_reset) begin
	   clk266_queue <= 'd0;
	 end else if (locked) begin
	   clk266_queue <= {clk266_queue[`CLK266_QSIZE-2:1], output_comb};
	 end
  end
  
  reg [`CLK400_QSIZE-1:0] clk400_queue;  
  always @(posedge clk400, posedge cpu_reset) begin
    if (cpu_reset) begin
	   clk400_queue <= 'd0;
	 end else if (locked) begin
	   clk400_queue <= {clk400_queue[`CLK400_QSIZE-2:1], output_comb};
	 end
  end
 
  ILA ILA100 (
    .CONTROL('d0),
    .CLK(clk100),
    .DATA(clk100_queue),
	 .TRIG0(locked));
  ILA ILA200 (
    .CONTROL('d0),
    .CLK(clk200),
    .DATA(clk200_queue),
	 .TRIG0(locked));
  ILA ILA266 (
    .CONTROL('d0),
    .CLK(clk266),
    .DATA(clk266_queue),
	 .TRIG0(locked));
  ILA ILA400 (
    .CONTROL('d0),
    .CLK(clk400),
    .DATA(clk400_queue),
	 .TRIG0(locked));
  
endmodule
