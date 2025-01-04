`timescale 1ns / 1ps
module testbench();
    // Inputs
    reg clk;
    reg rst_n;
    // Outputs
    wire clk_div;

    // Instantiate the Unit Under Test (UUT)
    freq_divbyeven uut (
        .clk(clk), 
        .rst_n(rst_n), 
        .clk_div(clk_div)
    );

    // Clock generation: toggle clk every 5 ns
    always #5 clk = ~clk;

    integer error = 0;
    integer expected_value = 0;
    integer i;

    initial begin
        // Initialize Inputs
        clk = 1;
        rst_n = 0; // Start with reset active
        #10 rst_n = 1; // Release reset
        #100; // Wait for some cycles

        $finish; // End simulation
    end

    initial begin
        #5; // Wait a short time before monitoring
        for (i = 1; i < 20; i = i + 1) begin
            if (clk_div !== expected_value) begin
                error = error + 1; 
                $display("Failed at %d: clk=%d, clk_div=%d (expected %d)", i, clk, clk_div, expected_value);
            end

            // Update expected value based on clock cycle
            if (i < 6) expected_value = 0; // First five pairs
            else if (i < 12) expected_value = 1; // Next five pairs
            else if (i < 18) expected_value = 0; // Next five pairs
            else expected_value = 1; // Last five pairs
            #5; // Wait for next clock cycle
        end
        
        // Final result output
        if (error == 0) begin
            $display("=========== Your Design Passed ===========");
        end else begin
            $display("=========== Test completed with %d/20 failures ===========", error);
        end
    end
endmodule