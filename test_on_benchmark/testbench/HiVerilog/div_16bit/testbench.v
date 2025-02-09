`timescale 1ns/1ps
module testbench();

    reg [15:0] A;
    reg [7:0] B;
    wire [15:0] result;
    wire [15:0] odd;

    integer i; 
    integer error = 0; 
    reg [15:0] expected_result;
    reg [15:0] expected_odd;

    // Instantiate the div_16bit module
    div_16bit uut (
        .A(A),
        .B(B),
        .result(result),
        .odd(odd)
    );

    initial begin
        // Run 100 test cases
        for (i = 0; i < 100; i = i + 1) begin
            A = $urandom_range(0, 16'hFFFF); // Random 16-bit dividend
            B = $urandom_range(1, 8'hFF);    // Random 8-bit divisor (avoid zero)
            expected_result = A / B;          // Expected quotient
            expected_odd = A % B;             // Expected remainder
            #10;                               // Wait for the module to process

            // Check results
            error = (expected_odd != odd || expected_result != result) ? error + 1 : error;

            // Uncomment to display values for debugging
            // $display("A = %d, B = %d, Result = %d, odd = %d", A, B, result, odd);
        end
        
        // Final report
        if (error == 0) begin
            $display("===========Your Design Passed===========");
        end else begin
            $display("===========Test completed with %d /100 failures===========", error);
        end
        
        $finish;
    end

endmodule