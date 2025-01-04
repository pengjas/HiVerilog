module testbench();

    reg clk, rst;

    wire out_50;
    wire out_10;
    wire out_1;

    // Instantiate the modular frequency divider
    freq_div dut (
        .CLK_in(clk),
        .RST(rst),
        .CLK_50(out_50),
        .CLK_10(out_10),
        .CLK_1(out_1)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    integer error = 0;

    initial begin 
        // Reset the system
        #10;
        rst = 1; // Assert reset
        #35;
        rst = 0; // Deassert reset

        // Check initial state
        error = (out_50 != 0 || out_10 != 0 || out_1 != 0) ? error + 1 : error;

        // Check for 50MHz clock
        #10;
        error = (out_50 != 1 || out_10 != 0 || out_1 != 0) ? error + 1 : error;

        // Check for 10MHz clock
        #40;
        error = (out_50 != 1 || out_10 != 1 || out_1 != 0) ? error + 1 : error;

        // Check for 50MHz clock falling edge
        #130;
        error = (out_50 != 0 || out_10 != 1 || out_1 != 0) ? error + 1 : error;

        // Check for 1MHz clock
        #400;
        error = (out_50 != 0 || out_10 != 1 || out_1 != 1) ? error + 1 : error;

        // All clocks should be high
        #410;
        error = (out_50 != 1 || out_10 != 1 || out_1 != 1) ? error + 1 : error;

        // Display results
        if (error == 0) begin
            $display("=========== Your Design Passed ===========");
        end else begin
            $display("=========== Error: %d ===========", error);
        end
        $finish;
    end

    // Optional: Monitoring the outputs
    // initial begin 
    //     repeat(500) begin
    //         #5
    //         $display("Time: %t, clk: %b, clk50: %b, clk10: %b, clk1: %b", $time, clk, out_50, out_10, out_1);
    //     end
    // end

endmodule