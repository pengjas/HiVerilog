module testbench();

    reg clk;
    reg reset;
    reg up_down;
    wire [15:0] count;

    // Instantiate the up_down_counter module
    up_down_counter uut (
        .clk(clk),
        .reset(reset),
        .up_down(up_down),
        .count(count)
    );

    integer error = 0;
    
    // Generate clock signal
    always begin
        #5 clk = ~clk;
    end

    // Initial block for setup
    initial begin
        clk = 0;
        reset = 1;
        up_down = 1; 
        #10 reset = 0; // Release reset
    end

    // Test counting up
    initial begin
        #20 up_down = 1; // Start counting up
        #100 up_down = 0; // Switch to counting down
        #100 up_down = 1; // Switch back to counting up
        #100 up_down = 0; // Switch to counting down again
        #200;
        
        // Error checking for expected values
        if (count != 16'b1111_1111_1111_1111) begin
            error = error + 1; // Check if the count is 65535 after overflow
        end

        #10 reset = 1; // Reset the counter
        #10 reset = 0; // Release reset

        #20 up_down = 1; // Count up again
        #100; // Allow time for counting

        // Final error checking
        if (count != 16'b0000_0000_0000_0000) begin
            error = error + 1; // Check if the count is 0 after reset
        end

        // Display results
        if (error == 0) begin
            $display("=========== Your Design Passed ===========");
        end else begin
            $display("=========== Test completed with %d failures ===========", error);
        end

        $finish;
    end

endmodule