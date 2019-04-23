module tb;

	logic reset, signal;

	ro dut(.*);

	initial begin

		$monitor("%t : %b", $time, signal);

		force dut.out[0] = 0;
		#6 release dut.out[0];

		#100;

		$finish;

	end

endmodule