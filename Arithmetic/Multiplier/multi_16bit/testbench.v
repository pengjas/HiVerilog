module testbench();

  reg clk;
  reg rst_n;
  reg start;
  reg [15:0] ain;
  reg [15:0] bin;
  wire [31:0] yout;
  wire done;

  integer i; // Loop variable
  integer fail_count = 0; // Variable to count the failures
  reg [31:0] expected_product; // Variable to store the expected product

  // Instantiate the multi_16bit module
  multi_16bit uut (
    .clk(clk), 
    .rst_n(rst_n),
    .start(start),
    .ain(ain), 
    .bin(bin), 
    .yout(yout),
    .done(done)
  );

  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  // Test logic
  initial begin
    clk = 0; // Initialize clock
    rst_n = 1; // De-assert reset
    start = 0; // Initialize start

    // Perform reset
    rst_n = 0; 
    #20;
    rst_n = 1; // Release reset

    // Randomize inputs and check output
    for (i = 0; i < 100; i = i + 1) begin
      ain = $random; // Random multiplicand
      bin = $random; // Random multiplier
      #10;
      start = 1; // Start the operation
      #10;
      start = 0; // Stop the operation

      // Wait for the multiplication to complete
      while (done !== 1) begin
        #10;
      end

      expected_product = ain * bin; // Calculate expected product

      // Check result
      if (yout !== expected_product) begin
        fail_count = fail_count + 1; // Increment failure count if mismatch
        // $display("Test %0d Failed: %0d * %0d = %0d (Expected: %0d)", i, ain, bin, yout, expected_product);
      end else begin
        // $display("Test %0d Passed: %0d * %0d = %0d", i, ain, bin, yout);
      end

      // Reset for the next test
      rst_n = 0;
      #20;
      rst_n = 1;
      #10;
    end

    // Final report
    if (fail_count == 0) begin
        $display("===========Your Design Passed===========");
      // $display("=========== Your Design Passed All Tests ===========");
    end else begin
    $display("===========Test completed with %d / 100 failures===========", fail_count);
      // $display("=========== Test Completed with %d / 100 Failures ===========", fail_count);
    end

    $finish;
  end

  initial begin
    #50000; // Timeout to prevent simulation hang
    $finish;
  end

endmodule