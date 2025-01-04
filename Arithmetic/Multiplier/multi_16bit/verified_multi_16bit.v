module verified_multi_16bit (
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal.
    input start,        // Chip enable signal.
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.
    output [31:0] yout, // Product output with a data width of 32 bits.
    output done         // Chip output flag signal.
);

    // Internal wires and registers
    wire [15:0] areg;
    wire [15:0] breg;
    wire [31:0] yout_r;
    wire done_r;
    wire [4:0] i;

    // Instantiate the control unit
    control_unit ctrl (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .i(i),
        .done(done_r)
    );

    // Instantiate the register unit
    register_unit reg_unit (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .ain(ain),
        .bin(bin),
        .i(i),
        .areg(areg),
        .breg(breg),
        .yout_r(yout_r)
    );

    // Instantiate the multiplier unit
    multiplier_unit mul_unit (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .i(i),
        .areg(areg),
        .breg(breg),
        .yout_r(yout_r)
    );

    // Output assignments
    assign done = done_r;
    assign yout = yout_r;

endmodule

// Control Unit
module control_unit (
    input clk,
    input rst_n,
    input start,
    output reg [4:0] i,
    output reg done
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
            done <= 1'b0;
        end
        else if (start && i < 5'd17) begin
            i <= i + 1'b1;
        end
        else if (!start) begin
            i <= 5'd0;
        end

        // Update done flag
        if (i == 5'd16) done <= 1'b1;    // Multiplication completion
        else if (i == 5'd17) done <= 1'b0; // Reset flag
    end

endmodule

// Register Unit
module register_unit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    input [4:0] i,
    output reg [15:0] areg,
    output reg [15:0] breg,
    output reg [31:0] yout_r
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'h0000;
            breg <= 16'h0000;
            yout_r <= 32'h00000000;
        end
        else if (start) begin
            if (i == 5'd0) begin
                areg <= ain;  // Store multiplicand
                breg <= bin;  // Store multiplier
            end
        end
    end

endmodule

// Multiplier Unit
module multiplier_unit (
    input clk,
    input rst_n,
    input start,
    input [4:0] i,
    input [15:0] areg,
    input [15:0] breg,
    output reg [31:0] yout_r
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            yout_r <= 32'h00000000;
        end
        else if (start) begin
            if (i > 5'd0 && i < 5'd17) begin
                if (areg[i-1]) 
                    yout_r <= yout_r + ({16'h0000, breg} << (i-1)); // Accumulate and shift
            end
        end
    end

endmodule