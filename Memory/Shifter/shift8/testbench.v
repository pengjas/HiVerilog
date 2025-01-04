`timescale 1ns / 1ps

module testbench();

    reg clk;
    reg [7:0] d;
    reg [1:0] sel;

    wire [7:0] q;

    // Instantiate the top_module
    shift8 uut (
        .clk(clk),
        .d(d),
        .sel(sel),
        .q(q)
    );

    integer error;
    integer expected_q;

    initial begin
        // Initialize Inputs
        clk = 0;
        d = 8'd0;
        sel = 2'b00;
        error = 0;

        // Wait 10 ns for initialization
        #10;

        // Test case sequence
        // Cycle 1: d = 3, sel = 0
        d = 8'd3; sel = 2'b00; #10;
        expected_q = 8'd3;
        check_output(expected_q);

        // Cycle 2: d = 4, sel = 1
        d = 8'd4; sel = 2'b01; #10;
        expected_q = 8'd3; // Output of first flip-flop
        check_output(expected_q);

        // Cycle 3: d = 5, sel = 2
        d = 8'd5; sel = 2'b10; #10;
        expected_q = 8'd4; // Output of second flip-flop
        check_output(expected_q);

        // Cycle 4: d = 6, sel = 3
        d = 8'd6; sel = 2'b11; #10;
        expected_q = 8'd5; // Output of third flip-flop
        check_output(expected_q);

        // Cycle 5: d = 7, sel = 0
        d = 8'd7; sel = 2'b00; #10;
        expected_q = 8'd7;
        check_output(expected_q);

        // Cycle 6: d = 8, sel = 1
        d = 8'd8; sel = 2'b01; #10;
        expected_q = 8'd7; // Output of first flip-flop
        check_output(expected_q);

        // Cycle 7: d = 9, sel = 2
        d = 8'd9; sel = 2'b10; #10;
        expected_q = 8'd8; // Output of second flip-flop
        check_output(expected_q);

        // Cycle 8: d = 10, sel = 3
        d = 8'd10; sel = 2'b11; #10;
        expected_q = 8'd9; // Output of third flip-flop
        check_output(expected_q);

        // Finish simulation and display total errors
        if (error == 0) begin
            $display("=========== Your Design Passed ===========");
        end else begin
            $display("=========== Test completed with %d failures ===========", error);
        end
        $finish;
    end

    // Clock generation
    always #5 clk = ~clk;

    // Task to check output
    task check_output(input [7:0] expected);
        if (q !== expected) begin
            error = error + 1;
            $display("Error: Expected q = %d, but got %d at time %t", expected, q, $time);
        end
    endtask

endmodule