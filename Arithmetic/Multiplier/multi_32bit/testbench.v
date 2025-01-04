`timescale  1ns/1ns
module testbench();

  reg [31:0] A;
  reg [31:0] B;
  wire [63:0] P;

  integer i; 
  integer error = 0; 
  reg [63:0] expected_product; 
  
  // Instantiate the module
  multiplier_32bit uut (
    .A(A), 
    .B(B), 
    .P(P)
  );
  
  // Randomize inputs and check output
  initial begin
    for (i = 0; i < 100; i = i + 1) begin
      A = $random;
      B = $random;
      #10; 
      // Calculate expected product
      expected_product = A * B;
      error = (P !== expected_product) ? error + 1 : error; 
    end
    if (error == 0) begin
      $display("===========Your Design Passed===========");
    end
    else begin
      $display("===========Test completed with %d /100 failures===========", error);
    end
  end

endmodule