`timescale 1ns / 1ns
module testbench();

    reg [16:1] A;
    reg [16:1] B;
    wire [16:1] D;
    wire B_out;

    integer i; 
    integer error = 0; 
    reg [16:1] expected_difference; 

    // Instantiate the module
    sub_16bit uut (
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
            // Calculate expected difference
            expected_difference = A - B;
            // Check if the output is as expected
            if (D !== expected_difference || B_out !== (A < B)) begin
                error = error + 1; 
                $display("Error at A: %b, B: %b | Expected: D: %b, B_out: %b | Got: D: %b, B_out: %b", 
                         A, B, expected_difference, (A < B), D, B_out);
            end
        end
        if (error == 0) begin
            $display("===========Your Design Passed===========");
        end else begin
            $display("===========Test completed with %d /100 failures===========", error);
        end
    end

endmodule