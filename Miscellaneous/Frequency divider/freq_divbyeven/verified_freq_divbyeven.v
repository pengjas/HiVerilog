module freq_divbyeven(
    input clk,
    input rst_n,
    output clk_div
);
    // Parameter for division factor
    parameter NUM_DIV = 6;

    // Internal wire for the counter value
    wire [3:0] cnt_value;
    // Internal wire for the divided clock signal
    wire clk_div_internal;

    // Instantiate the counter submodule
    counter #(NUM_DIV) u_counter (
        .clk(clk),
        .rst_n(rst_n),
        .cnt_value(cnt_value)
    );

    // Instantiate the clock divider submodule
    clk_divider u_clk_divider (
        .clk(clk),
        .rst_n(rst_n),
        .cnt_value(cnt_value),
        .clk_div(clk_div_internal)
    );

    // Assign the internal divided clock to the output
    assign clk_div = clk_div_internal;

endmodule

// Counter submodule
module counter #(parameter NUM_DIV = 6)(
    input clk,
    input rst_n,
    output reg [3:0] cnt_value
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_value <= 4'd0;
        end else if (cnt_value < NUM_DIV / 2 - 1) begin
            cnt_value <= cnt_value + 1'b1;
        end else begin
            cnt_value <= 4'd0;
        end
    end
endmodule

// Clock divider submodule
module clk_divider(
    input clk,
    input rst_n,
    input [3:0] cnt_value,
    output reg clk_div
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div <= 1'b0;
        end else if (cnt_value == 0) begin
            clk_div <= ~clk_div;
        end
    end
endmodule