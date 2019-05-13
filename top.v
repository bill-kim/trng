`timescale 1ns / 1ps
`define CLK100_QSIZE 256
`define CLK100_QSIZE_LOG 8
`define CLK200_QSIZE 256
`define CLK200_QSIZE_LOG 8

module top(clk_p, clk_n, cpu_reset, gpio_c, clock, led);
   
  input clk_p, clk_n, cpu_reset, gpio_c, clock;
  output reg led;
  
  wire clk100, clk200, locked;
  clock_wiz cw(
    .CLKIN1_N_IN(clk_n), 
    .CLKIN1_P_IN(clk_p), 
    .RST_IN(~cpu_reset), 
    .CLKOUT0_OUT(clk100),
    .CLKOUT1_OUT(clk200),
    .LOCKED_OUT(locked));
	
  always @(posedge clock) begin
    if (~cpu_reset) begin
	   led <= 1'b0;
	 end else begin
	   led <= gpio_c;
	 end
  end
   
  wire output_comb100, output_comb200;
  ro_comb rc100(.clock(clk100), .output_comb(output_comb100));
  ro_comb rc200(.clock(clk200), .output_comb(output_comb200));
  
  reg [`CLK100_QSIZE-1:0] clk100_mem;
  reg [`CLK100_QSIZE_LOG-1:0] clk100_index;
  wire vio_op100;
  always @(posedge clk100) begin
    if (~cpu_reset) begin
      clk100_mem <= `CLK100_QSIZE'd0;
      clk100_index <= `CLK100_QSIZE_LOG'd0;
    end else if (vio_op100 && clk100_index < 'd`CLK100_QSIZE - 'd1) begin 
      clk100_mem[clk100_index] <= output_comb100;
      clk100_index <= clk100_index + `CLK100_QSIZE_LOG'd1;
    end
  end
  
  reg [`CLK200_QSIZE-1:0] clk200_mem;
  reg [`CLK200_QSIZE_LOG-1:0] clk200_index;
  wire vio_op200;
  always @(posedge clk200) begin
    if (~cpu_reset) begin
      clk200_mem <= `CLK200_QSIZE'd0;
      clk200_index <= `CLK200_QSIZE_LOG'd0;
    end else if (vio_op200 && clk200_index < 'd`CLK200_QSIZE - 'd1) begin 
      clk200_mem[clk200_index] <= output_comb200;
      clk200_index <= clk200_index + `CLK200_QSIZE_LOG'd1;
    end
  end

  wire [35:0] ilactrlbus, vioctrlbus;  
  
  wire [`CLK100_QSIZE-1:0] mem;
  wire mem_choose;
  assign mem = (mem_choose) ? clk200_mem : clk100_mem;
  
  ICON ICON100 (
    .CONTROL0(vioctrlbus),
    .CONTROL1(ilactrlbus));  
  VIO VIO100 (
    .CONTROL(vioctrlbus),
	 .ASYNC_IN(mem),
    .ASYNC_OUT({mem_choose, vio_op200, vio_op100})); 
  ILA ILA100 (
    .CONTROL(ilactrlbus),
    .CLK(clock),
    .DATA({output_comb200, output_comb100}),
    .TRIG0(locked));
	 
endmodule
