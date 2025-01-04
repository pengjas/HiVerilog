module freq_divbyfrac(
    input               clk,
    input               rst_n,
    output              clk_div
);
    // Parameter for fractional division factor
    parameter MUL2_DIV_CLK = 7;

    // Internal wires for clock signals
    wire clk_ave;
    wire clk_adjust;

    // Instantiate the counter submodule
    counter #(MUL2_DIV_CLK) u_counter (
        .clk(clk),
        .rst_n(rst_n),
        .cnt_value(cnt)
    );

    // Instantiate the average clock generator submodule
    clk_average u_clk_average (
        .clk(clk),
        .rst_n(rst_n),
        .cnt(cnt),
        .clk_ave(clk_ave)
    );

    // Instantiate the clock adjustment submodule
    clk_adjustment u_clk_adjustment (
        .clk(clk),
        .rst_n(rst_n),
        .cnt(cnt),
        .clk_adjust(clk_adjust)
    );

    // Final output: OR the adjusted and averaged clock signals
    assign clk_div = clk_adjust | clk_ave;

endmodule

// Counter submodule
module counter #(parameter MUL2_DIV_CLK = 7)(
    input clk,
    input rst_n,
    output reg [3:0] cnt_value
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_value <= 4'b0;
        end else if (cnt_value == MUL2_DIV_CLK - 1) begin
            cnt_value <= 4'b0;
        end else begin
            cnt_value <= cnt_value + 1'b1;
        end
    end
endmodule

// Clock Average Generator submodule
module clk_average #(parameter MUL2_DIV_CLK = 7)(
    input clk,
    input rst_n,
    input [3:0] cnt,
    output reg clk_ave
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_ave <= 1'b0;
        end else if (cnt == 0) begin
            clk_ave <= 1'b1;  // First cycle: 4 source clock cycles
        end else if (cnt == (MUL2_DIV_CLK / 2) + 1) begin
            clk_ave <= 1'b1;  // Second cycle: 3 source clock cycles
        end else begin
            clk_ave <= 1'b0;
        end
    end
endmodule

// Clock Adjustment submodule
module clk_adjustment #(parameter MUL2_DIV_CLK = 7)(
    input clk,
    input rst_n,
    input [3:0] cnt,
    output reg clk_adjust
);
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_adjust <= 1'b0;
        end else if (cnt == 1) begin
            clk_adjust <= 1'b1;  // Adjust clock signal
        end else if (cnt == (MUL2_DIV_CLK / 2) + 1) begin
            clk_adjust <= 1'b1;  // Adjust clock signal again
        end else begin
            clk_adjust <= 1'b0;
        end
    end
endmodule