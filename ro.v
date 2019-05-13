`default_nettype none

(* KEEP_HIERARCHY="TRUE" *)

module ro #(parameter SIZE = 3, DELAY = 2) (
  input wire enable,
  input wire clock,
  output wire signal);

  (* S = "TRUE" *)

	wire out[SIZE-1:0];
  wire init_val;

  nor #(DELAY) (out[0], out[SIZE-1], enable);

	genvar i;
	generate
		for (i = 0; i < SIZE - 1; i = i + 1) begin: not_gates
			not #(DELAY) (out[i+1], out[i]);
		end
	endgenerate

  assign signal = out[SIZE-1];

endmodule
