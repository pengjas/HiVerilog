`timescale  1ns / 1ps

module testbench();

parameter PERIOD = 10;
reg clk = 0;
reg rst_n = 0;
reg [7:0] data_in = 0;
reg valid_in = 0;

wire valid_out;
wire [9:0] data_out;

initial begin
    forever #(PERIOD/2) clk = ~clk;
end

initial begin
    #(PERIOD*2) rst_n = 1; // Release reset after 20 ns
end

// Instantiate the accumulator top module
accu uut (
    .clk(clk),
    .rst_n(rst_n),
    .data_in(data_in),
    .valid_in(valid_in),
    .valid_out(valid_out),
    .data_out(data_out)
);

initial begin
    // Apply test inputs
    #(PERIOD*1 + 0.01);
    
    // First set of inputs
    #(PERIOD) data_in = 8'd1; valid_in = 1; // Valid input 1
    #(PERIOD) data_in = 8'd2; // Valid input 2
    #(PERIOD) data_in = 8'd3; // Valid input 3
    #(PERIOD) data_in = 8'd14; // Valid input 4

    // Second set of inputs
    #(PERIOD) data_in = 8'd5; // Valid input 1
    #(PERIOD) data_in = 8'd2; // Valid input 2
    #(PERIOD) data_in = 8'd103; // Valid input 3
    #(PERIOD) data_in = 8'd4; // Valid input 4

    // Third set of inputs
    #(PERIOD) data_in = 8'd5; // Valid input 1
    #(PERIOD) data_in = 8'd6; // Valid input 2
    #(PERIOD) data_in = 8'd3; // Valid input 3
    #(PERIOD) data_in = 8'd54; // Valid input 4
    #(PERIOD*2);
    
    // End simulation
    $finish;
end

// Expected results
reg [9:0] expected_result [0:2];
initial begin
    expected_result[0] = 10'd20;   // 1 + 2 + 3 + 14
    expected_result[1] = 10'd114;  // 5 + 2 + 103 + 4
    expected_result[2] = 10'd68;   // 5 + 6 + 3 + 54
end

integer i;
integer case_num = 0;
integer error_count = 0;

initial begin
    for (i = 0; i < 15; i = i + 1) begin
        #(PERIOD);
        if (valid_out) begin
            if (data_out !== expected_result[case_num]) begin
                error_count = error_count + 1;
                // $display("Error: Expected %d, but got %d at case %d", expected_result[case_num], data_out, case_num);
            end
            case_num = case_num + 1;
        end        
    end
    if (error_count == 0 && case_num == 3) begin
        $display("===========Your Design Passed===========");
    end else begin
        $display("===========Error: %d mismatch(s)===========", error_count);
    end
    $finish;
end

endmodule