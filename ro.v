`default_nettype none

module ro #(SIZE = 3, DELAY = 2) (
  output wire signal);

	wire out[SIZE-1:0];

	genvar i;
	generate
		for (i = 0; i < SIZE - 1; i = i + 1) begin: not_gates
			not #(DELAY) (out[i+1], out[i]);
		end
	endgenerate

	not #(DELAY) (out[0], out[SIZE-1]);

	assign signal = out[SIZE-1];

endmodule
