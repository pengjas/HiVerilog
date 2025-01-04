`timescale 1ns/1ns
module testbench();
  
  reg [31:0] A;
  reg [31:0] B;
  wire [31:0] Diff;
  wire B_out;
  
  integer i; 
  integer error = 0; 
  reg [33:0] expected_diff; 
  
  // Instantiate the module
  sub_32bit uut (
    .A(A), 
    .B(B), 
    .Diff(Diff), 
    .B_out(B_out)
  );
  
  // Randomize inputs and check output
  initial begin
    for (i = 0; i < 100; i = i + 1) begin
      A = $random;
      B = $random;
      #10; 
      // Calculate expected difference and borrow out
      expected_diff = A - B;
      error = (Diff !== expected_diff[31:0] || B_out !== (A < B)) ? error + 1 : error; 
    end
    if (error == 0) begin
            $display("===========Your Design Passed===========");
    end
    else begin
            $display("===========Test completed with %d /100 failures===========", error);
    end
  end

endmodule