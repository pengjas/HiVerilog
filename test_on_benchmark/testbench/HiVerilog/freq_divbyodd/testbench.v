`timescale 1ns / 1ps
module testbench();
    // Inputs
    reg clk;
    reg rst_n;
    // Outputs
    wire clk_div;

    // Instantiate the Unit Under Test (UUT)
    freq_divbyodd uut (
        .clk(clk), 
        .rst_n(rst_n), 
        .clk_div(clk_div)
    );

    // Clock generation
    always #5 clk = ~clk;

    integer error = 0;
    integer expected_value = 1;
    integer i;

    initial begin
        // Initialize inputs
        clk = 1;
        rst_n = 0;
        #10 rst_n = 1; // Release reset
        #120; // Wait for a while to observe the output

        $finish;
    end

    initial begin
        // Monitor output values
        #15;
        for (i = 1; i < 20; i = i + 1) begin
            if (clk_div !== expected_value) begin
                error = error + 1; 
                $display("Failed at %d: clk=%d, clk_div=%d (expected %d)", i, clk, clk_div, expected_value);
            end

            // Update expected value based on the clock period
            if (i < 5) expected_value = 1; 
            else if (i < 10) expected_value = 0; 
            else if (i < 15) expected_value = 1; 
            else expected_value = 0; 
            #5; // Wait for next clock cycle
        end

        if (error == 0) begin
            $display("=========== Your Design Passed ===========");
        end else begin
            $display("=========== Test completed with %d/20 failures ===========", error);
        end
    end
endmodule