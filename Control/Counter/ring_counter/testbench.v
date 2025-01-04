module testbench();

    reg clk;
    reg reset;
    wire [7:0] out;

    // Instantiate the ring_counter module
    ring_counter ring_counter_inst (
        .clk(clk),
        .reset(reset),
        .out(out)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    reg [3:0] i;
    reg [7:0] expected_data [0:9] = {8'b00000001, 8'b00000001, 8'b00000010, 8'b00000100, 
                                       8'b00001000, 8'b00010000, 8'b00100000, 8'b01000000, 
                                       8'b10000000, 8'b00000001};

    initial begin
        clk = 0;
        reset = 1;
        i = 0;
        #10 reset = 0;  // Release reset after 10 time units
    end

    // Monitor the output to check for correctness
    always @(posedge clk) begin
        if (i < 10) begin
            if (out !== expected_data[i]) begin
                $display("Failed at i=%d, out=%b, expected=%b", i, out, expected_data[i]);
            end
            i = i + 1;
        end
    end

    // Stop simulation after checking all values
    always @(posedge clk) begin
        if (i == 10) begin
            $display("=========== Your Design Passed ===========");
            $finish;
        end
    end

    // Stop simulation after 100 clock cycles
    initial begin
        #100 $finish;
    end

endmodule