module verified_sub_32bit(A, B, Diff, B_out);
    input [31:0] A;  // 32-bit input operand A
    input [31:0] B;  // 32-bit input operand B
    output [31:0] Diff; // 32-bit output representing the difference A - B
    output B_out;    // Borrow-out output 

    wire [15:0] B_neg; // Negated B for 1's complement
    wire borrow1, borrow2;

    // Negate B (1's complement)
    assign B_neg = ~B[15:0];

    // First 16-bit subtractor instance
    subtractor_16 S1(
        .A(A[15:0]),
        .B(B_neg),
        .Borrow_in(1'b1), // Setting Borrow_in to 1 for 1's complement subtraction
        .Diff(Diff[15:0]),
        .Borrow_out(borrow1)
    );

    // Second 16-bit subtractor instance
    subtractor_16 S2(
        .A(A[31:16]),
        .B(~B[31:16]),
        .Borrow_in(borrow1),
        .Diff(Diff[31:16]),
        .Borrow_out(borrow2)
    );

    // Final borrow output
    assign B_out = borrow2;

endmodule

module subtractor_16(A, B, Borrow_in, Diff, Borrow_out);
    input [15:0] A;         // 16-bit input operand A
    input [15:0] B;         // 16-bit input operand B
    input Borrow_in;        // Borrow input
    output [15:0] Diff;     // 16-bit output representing the difference A - B
    output Borrow_out;      // Borrow output

    wire [15:0] B_complement; // 1's complement of B
    wire [15:0] temp_diff;    // Temporary difference
    wire borrow;              // Intermediate borrow

    // Compute 1's complement of B
    assign B_complement = ~B;

    // Full subtractor logic: Diff = A - B + Borrow_in
    assign {borrow, temp_diff} = A + B_complement + Borrow_in;

    // Assign outputs
    assign Diff = temp_diff;
    assign Borrow_out = borrow;

endmodule