`timescale 1ns / 1ps
`define CLK100_QSIZE 1000
`define CLK100_QSIZE_LOG 10
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
  ro_comb rc(.clock(clk100), .output_comb(output_comb));
  
  reg [`CLK100_QSIZE-1:0] clk100_mem;
  reg [`CLK100_QSIZE_LOG-1:0] clk100_index;  
  wire index_reset;
  always @(posedge clk100, posedge cpu_reset) begin
    if (cpu_reset) begin
      clk100_mem <= `CLK100_QSIZE'd0;
      clk100_index <= `CLK100_QSIZE_LOG'd0;
    end else if (locked && clk100_index < `CLK100_QSIZE_LOG'd`CLK100_QSIZE) begin 
      clk100_mem[clk100_index] <= output_comb;
      clk100_index <= clk100_index + `CLK100_QSIZE_LOG'd1;
    end
  end
  
  /*reg [`CLK200_QSIZE-1:0] clk200_queue;  
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
  end*/

  //wire [35:0] ilactrlbus100, ilactrlbus200, ilactrlbus266, ilactrlbus400,
  //            vioctrlbus100, vioctrlbus200, vioctrlbus266, vioctrlbus400;
  wire [35:0] ilactrlbus100, vioctrlbus100;  
  
  wire vio_op100, vio_op200, vio_op266, vio_op400;
  assign index_reset = vio_op100;// | vio_op200 | vio_op266 | vio_op400;
  
  ICON ICON100 (
    .CONTROL0(vioctrlbus100),
    .CONTROL1(ilactrlbus100));  
  VIO VIO100 (
    .CONTROL(vioctrlbus100),
    .ASYNC_OUT(vio_op100)); 
  ILA ILA100 (
    .CONTROL(ilactrlbus100),
    .CLK(clk100),
    .DATA({locked,clk100_mem}),
    .TRIG0(locked));
  /*
  ICON ICON200 (
    .CONTROL0(vioctrlbus200),
    .CONTROL1(ilactrlbus200));  
  VIO VIO200 (
    .CONTROL(vioctrlbus200),
    .ASYNC_OUT(vio_op200));
  ILA ILA200 (
    .CONTROL(ilactrlbus200),
    .CLK(clk200),
    .DATA(clk200_queue),
    .TRIG0(locked));
   
  ICON ICON266 (
    .CONTROL0(vioctrlbus266),
    .CONTROL1(ilactrlbus266));  
  VIO VIO266 (
    .CONTROL(vioctrlbus266),
    .ASYNC_OUT(vio_op266));
  ILA ILA266 (
    .CONTROL(ilactrlbus266),
    .CLK(clk266),
    .DATA(clk266_queue),
    .TRIG0(locked));

  ICON ICON400 (
    .CONTROL0(vioctrlbus400),
    .CONTROL1(ilactrlbus400));  
  VIO VIO400 (
    .CONTROL(vioctrlbus400),
    .ASYNC_OUT(vio_op400));
  ILA ILA400 (
    .CONTROL(ilactrlbus400),
    .CLK(clk400),
    .DATA(clk400_queue),
    .TRIG0(locked));*/
  
endmodule
