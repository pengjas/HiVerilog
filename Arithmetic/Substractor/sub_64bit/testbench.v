`timescale  1ns/1ns
module testbench();

  reg [63:0] A;
  reg [63:0] B;
  wire [63:0] D;
  wire B_out;
  
  integer i; 
  integer error = 0; 
  reg [64:0] expected_diff;  // 65 bits to handle potential borrow

  // Instantiate the module
  sub_64bit uut (
    .A(A), 
    .B(B), 
    .D(D), 
    .B_out(B_out)
  );
  
  // Randomize inputs and check output
  initial begin
    for (i = 0; i < 100; i = i + 1) begin
      A = $random;
      B = $random;
      #10; 
      // Calculate expected difference and borrow
      expected_diff = A - B;  // Using signed subtraction to handle borrow
      error = (D !== expected_diff[63:0] || B_out !== expected_diff[64]) ? error + 1 : error; 
    end
    if (error == 0) begin
      $display("===========Your Design Passed===========");
    end
    else begin
      $display("===========Test completed with %d /100 failures===========", error);
    end
  end

endmodule