`timescale 1ns/1ps

// Main counter module
module verified_counter_12 (
    input rst_n,
    input clk,
    input valid_count,
    output [3:0] out
);

    // Internal signal for counting
    wire [3:0] count_value;

    // Instance of the counter logic module
    counter_logic u_counter_logic (
        .rst_n(rst_n),
        .clk(clk),
        .valid_count(valid_count),
        .count_value(count_value)
    );

    // Instance of the output register module
    output_register u_output_register (
        .rst_n(rst_n),
        .clk(clk),
        .valid_count(valid_count),
        .count_value(count_value),
        .out(out)
    );

endmodule

// Counter logic module
module counter_logic (
    input rst_n,
    input clk,
    input valid_count,
    output reg [3:0] count_value
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_value <= 4'b0000;
        end else if (valid_count) begin
            if (count_value == 4'd11) begin
                count_value <= 4'b0000;
            end else begin
                count_value <= count_value + 1;
            end
        end
    end

endmodule

// Output register module
module output_register (
    input rst_n,
    input clk,
    input valid_count,
    input [3:0] count_value,
    output reg [3:0] out
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out <= 4'b0000;
        end else if (valid_count) begin
            out <= count_value;
        end else begin
            out <= out; // Pause the count when valid_count is invalid
        end
    end

endmodule