`timescale 1ns / 1ps

module testbench();

    reg clk;
    reg d;
    wire q;

    // Instantiate the shift register module
    shift_reg uut (
        .clk(clk),
        .d(d),
        .q(q)
    );

    integer error;
    reg [2:0] expected_q; // To hold expected values for q
    integer i;

    initial begin
        // Initialize Inputs
        clk = 0;
        d = 0;
        error = 0;

        // Wait 100 ns for initialization
        #100;

        // Test case 1: Shift in '1'
        d = 1; // Input data
        #10;   // Wait for a clock edge
        // Check the expected output
        expected_q = 3'b100; // After one clock cycle, q should be '0'.
        // #10; // Wait for the next clock edge
        if (q !== expected_q[0]) begin
            error = error + 1; 
            $display("Failed at test case 1: clk=%d, q=%b (expected %d)", clk, q, expected_q[0]);
        end

        // Test case 2: Shift in '0'
        d = 0; // Input data
        #10;  // Wait for a clock edge
        expected_q = {1'b0, expected_q[2:1]}; // Shift '1' out, expect '0' in the least significant bit
        // #10; // Wait for the next clock edge
        if (q !== expected_q[0]) begin
            error = error + 1; 
            $display("Failed at test case 2: clk=%d, q=%b (expected %d)", clk, q, expected_q[0]);
        end

        // Test case 3: Shift in '1'
        d = 1; // Input data
        #10;  // Wait for a clock edge
        expected_q = {1'b1, expected_q[2:1]}; // Shift '0' out, expect '1' in the least significant bit
        // #10; // Wait for the next clock edge
        if (q !== expected_q[0]) begin
            error = error + 1; 
            $display("Failed at test case 3: clk=%d, q=%b (expected %d)", clk, q, expected_q[0]);
        end

        // Additional test cases can be added here as needed

        // Finish simulation and display total errors
        if (error == 0) begin
            $display("=========== Your Design Passed ===========");
        end else begin
            $display("=========== Test completed with %d failures ===========", error);
        end
        $finish;
    end

    // Generate clock signal
    always #5 clk = ~clk;

endmodule