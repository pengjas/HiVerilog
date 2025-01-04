`timescale 1ns/1ps
module testbench();

reg [31:0] A;
reg [15:0] B;
wire [31:0] result;
wire [31:0] odd;

integer i; 
integer error = 0; 
reg [31:0] expected_result;
reg [31:0] expected_odd;

initial begin
   for (i = 0; i < 100; i = i + 1) begin
      A = $urandom_range(0, 32'hFFFFFFFF); // Random 32-bit dividend
      B = $urandom_range(1, 32'hFFFF);     // Random 16-bit divisor (non-zero)
      expected_result = A / B;             // Calculate expected quotient
      expected_odd = A % B;                // Calculate expected remainder
      #10; 
      error = (expected_odd != odd || expected_result != result) ? error + 1 : error;
      // Uncomment the following line to display values during simulation
      // $display("A = %d, B = %d, Result = %d, odd = %d", A, B, result, odd);
   end
   
   if (error == 0) begin
       $display("===========Your Design Passed===========");
   end
   else begin
       $display("===========Test completed with %d /100 failures===========", error);
   end
    
   $finish;
end

div_32bit uut (.A(A), .B(B), .result(result), .odd(odd));

endmodule