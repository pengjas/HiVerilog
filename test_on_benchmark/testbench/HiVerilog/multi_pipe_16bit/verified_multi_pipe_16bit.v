module verified_multi_pipe_16bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [15:0] mul_a,
    input [15:0] mul_b,
    output reg mul_en_out,
    output reg [31:0] mul_out
);

    // Internal signals
    wire [31:0] partial_products [15:0];
    wire [31:0] sums [3:0];
    reg [15:0] mul_a_reg;
    reg [15:0] mul_b_reg;

    // Input Control Module
    input_control ic (
        .clk(clk),
        .rst_n(rst_n),
        .mul_en_in(mul_en_in),
        .mul_en_out(mul_en_out)
    );

    // Input Registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 16'd0;
            mul_b_reg <= 16'd0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Partial Product Generation
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : generate_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 32'd0;
        end
    endgenerate

    // Partial Sum Calculation Module
    partial_sum ps (
        .clk(clk),
        .rst_n(rst_n),
        .partial_products(partial_products),
        .sums(sums)
    );

    // Final Product Calculation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 32'd0;
        end else begin
            mul_out <= sums[0] + sums[1] + sums[2] + sums[3];
        end
    end

endmodule

// Input Control Module
module input_control (
    input clk,
    input rst_n,
    input mul_en_in,
    output reg mul_en_out
);
    reg [2:0] mul_en_out_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out_reg <= 3'd0;
            mul_en_out <= 1'b0;
        end else begin
            mul_en_out_reg <= {mul_en_out_reg[1:0], mul_en_in};
            mul_en_out <= mul_en_out_reg[2];
        end
    end
endmodule

// Partial Sum Calculation Module
module partial_sum (
    input clk,
    input rst_n,
    input [31:0] partial_products [15:0],
    output reg [31:0] sums [3:0]
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sums[0] <= 32'd0;
            sums[1] <= 32'd0;
            sums[2] <= 32'd0;
            sums[3] <= 32'd0;
        end else begin
            sums[0] <= partial_products[0] + partial_products[1];
            sums[1] <= partial_products[2] + partial_products[3];
            sums[2] <= partial_products[4] + partial_products[5];
            sums[3] <= partial_products[6] + partial_products[7];
        end
    end
endmodule