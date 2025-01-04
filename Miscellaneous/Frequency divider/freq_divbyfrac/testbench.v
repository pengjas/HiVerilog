`timescale 1ns / 1ps
module testbench();
    // Inputs
    reg clk;
    reg rst_n;
    // Outputs
    wire clk_div;

    // Instantiate the Unit Under Test (UUT)
    freq_divbyfrac uut (
        .clk(clk), 
        .rst_n(rst_n), 
        .clk_div(clk_div)
    );

    // Clock generation: toggle clk every 5 ns
    always #5 clk = ~clk;

    integer error = 0;
    integer expected_value = 1;
    integer i;

    initial begin
        // Initialize Inputs
        clk = 1;
        rst_n = 0; // Start with reset active
        #10 rst_n = 1; // Release reset
        #120; // Wait for a sufficient number of cycles

        $finish; // End simulation
    end

    initial begin
        #15; // Wait a short time before monitoring
        for (i = 0; i < 20; i = i + 1) begin
            if (clk_div !== expected_value) begin
                error = error + 1; 
                $display("Failed at %d: clk=%d, clk_div=%d (expected %d)", i, clk, clk_div, expected_value);
            end

            // Update expected value based on clock cycle
            if (i < 2) expected_value = 1; 
            else if (i < 6) expected_value = 0; 
            else if (i < 9) expected_value = 1; 
            else if (i < 13) expected_value = 0; 
            else if (i < 16) expected_value = 1; 
            else if (i < 20) expected_value = 0; 
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