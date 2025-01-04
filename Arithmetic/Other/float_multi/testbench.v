module testbench();

reg [31:0] a, b;
wire [31:0] z;
reg clk, rst;

float_multi uut(clk, rst, a, b, z);
integer error = 0;

initial begin
    clk <= 0;
    rst <= 1;
    repeat(17000)
        #5 clk <= ~clk; // Clock generation
end

initial #13 rst <= 0; // Release reset

initial begin
    // Monitor outputs
    // $monitor("a=%b, b=%b, z=%b", a, b, z);
    
    #3
    repeat(2) begin
        #80;
        a = 32'b00111110100110011001100110011010; // Input 1
        b = 32'b00111110100110011001100110011010; // Input 2
    end
    
    #80
    error = (z == 32'b00111101101110000101000111101100) ? error : error + 1; // Expected output check
    if (error == 0) begin
        $display("=========== Your Design Passed ===========");
    end else begin
        $display("=========== Test completed with %d failures ===========", error);
    end
    
    // Additional test cases can be added here
    // Example of testing special cases
    #80;
    a = 32'b01111111100000000000000000000000; // Infinity
    b = 32'b00000000000000000000000000000000; // Zero
    #80;
    error = (z == 32'b01111111100000000000000000000000) ? error : error + 1; // Check for result equal to Infinity

    #80;
    a = 32'b01111111100000000000000000000000; // Infinity
    b = 32'b01111111100000000000000000000000; // Infinity
    #80;
    error = (z == 32'b01111111100000000000000000000000) ? error : error + 1; // Check for result equal to Infinity

    // Testing NaN
    #80;
    a = 32'b01111111110000000000000000000000; // NaN
    b = 32'b00111110000000000000000000000000; // Valid number
    #80;
    error = (z[30:23] == 8'b11111111 && z[22:0] != 0) ? error : error + 1; // Check for NaN result

    // Final results
    if (error == 0) begin
        $display("=========== All Tests Passed ===========");
    end else begin
        $display("=========== Test completed with %d failures ===========", error);
    end

    $finish;
end

endmodule