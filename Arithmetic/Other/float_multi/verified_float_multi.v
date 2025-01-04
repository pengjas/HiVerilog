module float_multi(clk, rst, a, b, z);

input clk, rst;
input [31:0] a, b;
output reg [31:0] z;

reg [2:0] counter;

// Submodule outputs
wire [23:0] a_mantissa, b_mantissa;
wire [9:0] a_exponent, b_exponent;
wire a_sign, b_sign;
wire [49:0] product;
wire [23:0] z_mantissa;
wire [9:0] z_exponent;
wire z_sign;

reg guard_bit, round_bit, sticky;

initial begin
    counter = 0;
end

// Counter control
always @(posedge clk or posedge rst) begin
    if (rst)
        counter <= 0;
    else
        counter <= counter + 1;
end

// Instantiate submodules
input_processing ip (
    .clk(clk),
    .rst(rst),
    .counter(counter),
    .a(a),
    .b(b),
    .a_mantissa(a_mantissa),
    .b_mantissa(b_mantissa),
    .a_exponent(a_exponent),
    .b_exponent(b_exponent),
    .a_sign(a_sign),
    .b_sign(b_sign)
);

special_case_handling sch (
    .clk(clk),
    .reset(rst),
    .counter(counter),
    .a_exponent(a_exponent),
    .b_exponent(b_exponent),
    .a_mantissa(a_mantissa),
    .b_mantissa(b_mantissa),
    .a_sign(a_sign),
    .b_sign(b_sign),
    .z(z)
);

normalization norm (
    .clk(clk),
    .counter(counter),
    .a_mantissa(a_mantissa),
    .b_mantissa(b_mantissa),
    .a_exponent(a_exponent),
    .b_exponent(b_exponent)
);

multiplication mul (
    .clk(clk),
    .counter(counter),
    .a_mantissa(a_mantissa),
    .b_mantissa(b_mantissa),
    .a_sign(a_sign),
    .b_sign(b_sign),
    .product(product),
    .z_sign(z_sign),
    .z_exponent(z_exponent)
);

rounding_adjustment ra (
    .clk(clk),
    .counter(counter),
    .product(product),
    .z_exponent(z_exponent),
    .z_mantissa(z_mantissa),
    .guard_bit(guard_bit),
    .round_bit(round_bit),
    .sticky(sticky)
);

// Final output generation
always @(posedge clk) begin
    if (counter == 3'b111) begin
        z[22:0] <= z_mantissa[22:0];
        z[30:23] <= z_exponent[7:0] + 127;
        z[31] <= z_sign;
        if ($signed(z_exponent) == -126 && z_mantissa[23] == 0)
            z[30:23] <= 0;
        if ($signed(z_exponent) > 127) begin // Overflow handling
            z[22:0] <= 0;
            z[30:23] <= 255;
            z[31] <= z_sign;
        end
    end
end

endmodule

// Submodule: Input Processing
module input_processing (
    input clk,
    input rst,
    input [2:0] counter,
    input [31:0] a,
    input [31:0] b,
    output reg [23:0] a_mantissa,
    output reg [23:0] b_mantissa,
    output reg [9:0] a_exponent,
    output reg [9:0] b_exponent,
    output reg a_sign,
    output reg b_sign
);
    always @(posedge clk) begin
        if(counter == 3'b001) begin
            a_mantissa <= a[22:0];
            b_mantissa <= b[22:0];
            a_exponent <= a[30:23] - 127;
            b_exponent <= b[30:23] - 127;
            a_sign <= a[31];
            b_sign <= b[31];
        end
    end
endmodule

// Submodule: Special Case Handling
module special_case_handling (
    input clk,
    input reset,
    input [2:0] counter,
    input [9:0] a_exponent,
    input [9:0] b_exponent,
    input [23:0] a_mantissa,
    input [23:0] b_mantissa,
    input a_sign,
    input b_sign,
    output reg [31:0] z
);
    always @(posedge clk) begin
        if (counter == 3'b010) begin
            // Handle NaN and INF
            // Similar logic as previous code, but modularized
            // ...
        end
    end
endmodule

// Submodule: Normalization
module normalization (
    input clk,
    input [2:0] counter,
    input [23:0] a_mantissa,
    input [23:0] b_mantissa,
    input [9:0] a_exponent,
    input [9:0] b_exponent
);
    always @(posedge clk) begin
        if (counter == 3'b011) begin
            // Normalize mantissas
            // ...
        end
    end
endmodule

// Submodule: Multiplication
module multiplication (
    input clk,
    input [2:0] counter,
    input [23:0] a_mantissa,
    input [23:0] b_mantissa,
    input a_sign,
    input b_sign,
    output reg [49:0] product,
    output reg [9:0] z_exponent,
    output reg z_sign
);
    always @(posedge clk) begin
        if (counter == 3'b100) begin
            // Multiply mantissas and handle signs
            // ...
        end
    end
endmodule

// Submodule: Rounding and Adjustment
module rounding_adjustment (
    input clk,
    input [2:0] counter,
    input [49:0] product,
    input [9:0] z_exponent,
    output reg [23:0] z_mantissa,
    output reg guard_bit,
    output reg round_bit,
    output reg sticky
);
    always @(posedge clk) begin
        if (counter == 3'b101) begin
            // Rounding logic
            // ...
        end
    end
endmodule