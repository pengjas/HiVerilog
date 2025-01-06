`timescale 1ns / 1ps

module test_pe();

    reg clk;
    reg rst;
    reg [31:0] a, b;
    wire [31:0] c;

    // Instantiate the pe module
    pe dut (
        .clk(clk),
        .rst(rst),
        .a(a),
        .b(b),
        .c(c)
    );

    initial begin
        // Initialize signals
        a = 0;
        b = 0;
        clk = 0;
        rst = 1; // Start with reset active

        // Release reset
        #5;
        clk = 1; // Rising edge
        #5;
        clk = 0; // Falling edge
        rst = 0; // Deactivate reset
        #5;

        // Test case 1
        a = 1; 
        b = 1; 
        #5;
        clk = 1; // Rising edge
        #5;
        clk = 0; // Falling edge

        // Test case 2
        a = 2; 
        b = 2; 
        #5;
        clk = 1; // Rising edge
        #5;
        clk = 0; // Falling edge

        // Test case 3
        a = 3; 
        b = 3; 
        #5;
        clk = 1; // Rising edge
        #5;
        clk = 0; // Falling edge

        // Check the final accumulated value
        // Expected accumulated value = 0 + (1*1) + (2*2) + (3*3) = 0 + 1 + 4 + 9 = 14
        if (c == 32'h0000000E) begin
            $display("===========Your Design Passed===========");
        end else begin
            $display("===========Error: Expected 0x0E, Got %h===========", c);
        end
    end

    // Clock generation
    // always begin
    //     #5 clk = ~clk; // Toggle clock every 5 ns
    // end

endmodule