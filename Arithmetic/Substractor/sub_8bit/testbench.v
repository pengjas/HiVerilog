`timescale 1ns/1ns
module testbench();

  reg [7:0] A;           // 8-bit input operand A
  reg [7:0] B;           // 8-bit input operand B
  wire [7:0] D;          // 8-bit output representing the difference
  wire B_out;            // Borrow output
  
  integer i; 
  integer error = 0; 
  reg [8:0] expected_diff; // 9 bits to accommodate possible borrow

  // Instantiate the module
  sub_8bit uut (
    .A(A), 
    .B(B), 
    .D(D), 
    .B_out(B_out)
  );
  
  // Randomize inputs and check output
  initial begin
    for (i = 0; i < 100; i = i + 1) begin
      A = $random % 256; // Limit A to 8 bits
      B = $random % 256; // Limit B to 8 bits
      #10; 
      // Calculate expected difference and borrow
      expected_diff = A - B;
      error = (D !== expected_diff[7:0] || B_out !== (expected_diff[8] ? 1 : 0)) ? error + 1 : error; 
    end
    if (error == 0) begin
      $display("===========Your Design Passed===========");
    end
    else begin
      $display("===========Test completed with %d /100 failures===========", error);
    end
  end

endmodule