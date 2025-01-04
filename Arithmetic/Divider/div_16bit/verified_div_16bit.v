module verified_div_16bit (
    input wire [15:0] A,       // 16-bit dividend
    input wire [7:0] B,       // 8-bit divisor
    output wire [15:0] result, // 16-bit quotient
    output wire [15:0] odd     // 16-bit remainder
);

    wire [15:0] quotient;
    wire [15:0] remainder;

    // Instantiate the control module
    control_unit ctrl (
        .A(A),
        .B(B),
        .quotient(quotient),
        .remainder(remainder)
    );

    // Assign outputs
    assign result = quotient;
    assign odd = remainder;

endmodule

module control_unit (
    input wire [15:0] A,
    input wire [7:0] B,
    output reg [15:0] quotient,
    output reg [15:0] remainder
);
    reg [31:0] tmp_a;
    reg [31:0] tmp_b;
    integer i;

    always @(*) begin
        // Initialize temporary variables
        tmp_a = {16'b0, A};        // Concatenate A to a 32-bit value
        tmp_b = {B, 16'b0};        // Concatenate B to a 32-bit value
        quotient = 0;              // Reset quotient
        remainder = 0;             // Reset remainder

        // Division algorithm
        for (i = 0; i < 16; i = i + 1) begin
            tmp_a = tmp_a << 1;    // Shift left to process the next bit
            if (tmp_a >= tmp_b) begin
                tmp_a = tmp_a - tmp_b; // Subtract divisor from dividend
                quotient[i] = 1;        // Set quotient bit to 1
            end else begin
                quotient[i] = 0;        // Set quotient bit to 0
            end
        end

        remainder = tmp_a[31:16]; // Assign remainder from the higher bits of tmp_a
    end
endmodule