`include "params.vh"

module ro_comb (
  output wire output_comb);

	wire singals[`NUM_OF_RO-1:0];
	wire xors[`NUM_OF_RO-2:0];
	
	genvar i;
	generate
		for (i = 0; i < `NUM_OF_RO; i = i + 1) begin: ring_oscillators
			ro #(`NUM_OF_GATES, `GATE_DELAY) ring (singals[i]);
		end

		xor (xors[0], signals[0], signals[1]);
		for (i = 0; i < `NUM_OF_RO-2; i++) begin: xor_gates
			xor (xors[i+1], xors[i], signals[i+1]);
		end
	endgenerate
  

endmodule
