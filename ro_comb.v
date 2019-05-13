`default_nettype none
`include "params.vh"

module ro_comb (
  input wire enable,
  input wire clock,
  output wire output_comb);

	wire signals[`NUM_OF_RO-1:0];
	reg [`NUM_OF_RO-1:0] xors[`LOG_NUM_OF_RO:0];
	integer k;

	genvar i, j;
	generate
		for (i = 0; i < `NUM_OF_RO; i = i + 1) begin: ring_oscillators
			(* KEEP = "TRUE" *) ro #(`NUM_OF_GATES, `GATE_DELAY) ring (enable, clock, signals[i]);
		end

		for (i = 0; i < `LOG_NUM_OF_RO; i = i + 1) begin: layers
			for (j = 0; j < `NUM_OF_RO / 2**i; j = j + 2) begin: xor_gates
        always @(posedge clock) begin
          xors[i+1][j/2] <= xors[i][j] ^ xors[i][j + 1];
        end
        //xor (xors[i+1][j/2], xors[i][j], xors[i][j + 1]);
      end
		end
	endgenerate

  always @(posedge clock) begin
    for (k = 0; k < `NUM_OF_RO; k = k + 1) begin
      xors[0][k] <= signals[k];
    end
  end

  assign output_comb = xors[`LOG_NUM_OF_RO][0];  

endmodule
