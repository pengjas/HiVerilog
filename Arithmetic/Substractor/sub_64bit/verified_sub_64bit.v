module verified_sub_64bit(A, B, D, B_out);
    input [63:0] A;         // 64-bit input operand A
    input [63:0] B;         // 64-bit input operand B
    output [63:0] D;        // 64-bit output representing the difference A - B
    output B_out;           // Borrow-out output

    wire borrow32;          // Borrow output from the lower 32 bits

    // Instantiate two 32-bit subtractors
    subtractor_32bit sub0 (
        .A(A[31:0]),
        .B(B[31:0]),
        .D(D[31:0]),
        .borrow_out(borrow32)
    );

    subtractor_32bit sub1 (
        .A(A[63:32]),
        .B(B[63:32]),
        .D(D[63:32]),
        .borrow_out(B_out)
    );

    // Handle borrow from the lower 32-bit subtractor
    assign B_out = borrow32;

endmodule

module subtractor_32bit(A, B, D, borrow_out);
    input [31:0] A;         // 32-bit input operand A
    input [31:0] B;         // 32-bit input operand B
    output [31:0] D;        // 32-bit output representing the difference A - B
    output borrow_out;      // Borrow-out output

    wire borrow16;          // Borrow output from the lower 16 bits

    // Instantiate two 16-bit subtractors
    subtractor_16bit sub0 (
        .A(A[15:0]),
        .B(B[15:0]),
        .D(D[15:0]),
        .borrow_out(borrow16)
    );

    subtractor_16bit sub1 (
        .A(A[31:16]),
        .B(B[31:16]),
        .D(D[31:16]),
        .borrow_out(borrow_out)
    );

    // Handle borrow from the lower 16-bit subtractor
    assign borrow_out = borrow_out | borrow16;

endmodule

module subtractor_16bit(A, B, D, borrow_out);
    input [15:0] A;         // 16-bit input operand A
    input [15:0] B;         // 16-bit input operand B
    output [15:0] D;        // 16-bit output representing the difference A - B
    output borrow_out;      // Borrow-out output

    wire borrow8;           // Borrow output from the lower 8 bits

    // Instantiate two 8-bit subtractors
    subtractor_8bit sub0 (
        .A(A[7:0]),
        .B(B[7:0]),
        .D(D[7:0]),
        .borrow_out(borrow8)
    );

    subtractor_8bit sub1 (
        .A(A[15:8]),
        .B(B[15:8]),
        .D(D[15:8]),
        .borrow_out(borrow_out)
    );

    // Handle borrow from the lower 8-bit subtractor
    assign borrow_out = borrow_out | borrow8;

endmodule

module subtractor_8bit(A, B, D, borrow_out);
    input [7:0] A;          // 8-bit input operand A
    input [7:0] B;          // 8-bit input operand B
    output [7:0] D;         // 8-bit output representing the difference A - B
    output borrow_out;      // Borrow-out output

    wire [7:0] B_in;        // Inverted B for subtraction
    wire borrow;            // Borrow signal

    assign B_in = ~B;       // Invert B for subtraction
    assign {borrow_out, D} = A + B_in + 1; // Perform A - B

endmodule