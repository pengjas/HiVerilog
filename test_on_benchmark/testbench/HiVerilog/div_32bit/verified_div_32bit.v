module verified_div_32bit(
    input wire [31:0] A,   // 32-bit dividend
    input wire [15:0] B,   // 16-bit divisor
    output wire [31:0] result, // 32-bit quotient
    output wire [31:0] odd      // 32-bit remainder
);

// Internal signals
wire [63:0] tmp_a; // For holding the shifted dividend
wire [63:0] tmp_b; // For holding the shifted divisor
reg [31:0] quotient; // To hold the final quotient
reg [31:0] remainder; // To hold the final remainder

// Instantiate the preparatory module
prep_dividend prep (
    .A(A),
    .B(B),
    .tmp_a(tmp_a),
    .tmp_b(tmp_b)
);

// Division operation module
div_operation div_op (
    .tmp_a(tmp_a),
    .tmp_b(tmp_b),
    .quotient(quotient),
    .remainder(remainder)
);

// Assign outputs
assign result = quotient;
assign odd = remainder;

endmodule

// Module to prepare the dividend and divisor
module prep_dividend(
    input wire [31:0] A,
    input wire [15:0] B,
    output reg [63:0] tmp_a,
    output reg [63:0] tmp_b
);

always @(*) begin
    tmp_a = {32'b0, A}; // Concatenate 32 zeros with A
    tmp_b = {B, 32'b0}; // Concatenate B with 32 zeros
end

endmodule

// Division operation module
module div_operation(
    input wire [63:0] tmp_a,
    input wire [63:0] tmp_b,
    output reg [31:0] quotient,
    output reg [31:0] remainder
);

integer i;

always @(*) begin
    quotient = 0;
    remainder = tmp_a; // Start with the full dividend

    for (i = 0; i < 32; i = i + 1) begin
        remainder = remainder << 1; // Shift left
        if (remainder >= tmp_b) begin
            remainder = remainder - tmp_b; // Subtract divisor
            quotient = quotient | (1 << (31 - i)); // Set the quotient bit
        end
    end
end

endmodule