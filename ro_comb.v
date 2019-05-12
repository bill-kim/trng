`default_nettype none
`include "params.vh"

module ro_comb (
  input wire enable,
  input wire clock,
  output wire output_comb);

	wire signals[`NUM_OF_RO-1:0];
	reg [`NUM_OF_RO:0] xors[$clog2(`NUM_OF_RO):0];
	
	genvar i, j;
	generate
		for (i = 0; i < `NUM_OF_RO; i = i + 1) begin: ring_oscillators
			ro #(`NUM_OF_GATES, `GATE_DELAY) ring (enable, clock, signals[i]);
		end

		for (i = 0; i < $clog2(`NUM_OF_RO); i = i + 1) begin: layers
			for (j = 0; j < `NUM_OF_RO / 2**i; j = j + 2) begin: xor_gates
        always @(posedge clock) begin
          xors[i+1][j/2] <= xors[i][j] ^ xors[i][j + 1];
        end
        //xor (xors[i+1][j/2], xors[i][j], xors[i][j + 1]);
      end
		end
	endgenerate

  always @(posedge clock) begin
    xors[0] <= signals;
  end

  assign output_comb = xors[$clog2(`NUM_OF_RO)][0];  

endmodule
