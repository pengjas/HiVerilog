`timescale 1ns/1ps
module testbench();

  reg clk, rst_n, valid_count;
  wire [3:0] out;

  counter_12 dut (
    .rst_n(rst_n),
    .clk(clk),
    .valid_count(valid_count),
    .out(out)
  );

  // Clock generation
  always #5 clk = ~clk;

  integer i = 0;
  integer error = 0;

  initial begin
    // Initialize signals
    clk = 0;
    rst_n = 0;
    valid_count = 0;

    // Release reset after 20 time units
    #20 rst_n = 1;

    // Test case 1: Verify that the counter is 0 after reset
    repeat(15) begin
      error = (out == 0) ? error : error + 1;
      #10;
    end

    // Test case 2: Start counting
    #100 valid_count = 1;
    repeat(12) begin
      error = (out == i) ? error : error + 1;
      i = i + 1;
      #10;
    end

    // Test case 3: Check wrap-around functionality
    #10 valid_count = 1;  // Ensure valid_count is still active
    repeat(5) begin
      error = (out == 0) ? error : error + 1;  // Check if it wraps back to 0
      #10;
    end

    // Test case 4: Pause counting
    valid_count = 0;
    repeat(5) begin
      error = (out == 11) ? error : error + 1; // Ensure output remains 11
      #10;
    end

    // Test case 5: Restart counting
    valid_count = 1;
    repeat(5) begin
      error = (out == (11 + i) % 12) ? error : error + 1; // Check counting continues
      i = i + 1;
      #10;
    end

    // Final results
    if (error == 0) begin
      $display("===========Your Design Passed===========");
    end else begin
      $display("===========Failed with %d Errors===========", error);
    end
    $finish;
  end

endmodule