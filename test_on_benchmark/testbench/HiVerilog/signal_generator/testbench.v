module testbench();
    reg clk;
    reg rst_n;
    wire [4:0] wave;

    signal_generator uut (
        .clk(clk),
        .rst_n(rst_n),
        .wave(wave)
    );

    reg [31:0] reference [0:99];

    integer i = 0;
    integer error = 0;

    initial begin
        // Load the reference waveform values
        $readmemh("tri_gen.txt", reference);
        clk = 0;
        rst_n = 0;

        // Reset the module
        #10;
        rst_n = 1;

        // Test for 100 clock cycles
        repeat (100) begin
            // Check for errors against reference values
            error = (wave == reference[i]) ? error : error + 1;
            #10; // Wait for the next clock cycle
            i = i + 1;
        end

        // Display results
        if (error == 0) begin
            $display("===========Your Design Passed===========");
        end else begin
            $display("===========Error: %d mismatches===========", error);
        end

        $finish;
    end

    // Clock generation
    always #5 clk = ~clk;

endmodule