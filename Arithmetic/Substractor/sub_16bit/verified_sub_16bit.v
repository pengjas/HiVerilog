module verified_sub_16bit(A, B, D, B_out);
    input [16:1] A;       // 16-bit input A
    input [16:1] B;       // 16-bit input B
    output [16:1] D;      // 16-bit difference output
    output B_out;         // Borrow out

    wire b4, b8, b12;

    // Instantiate 4-bit subtractors
    subtractor_4 sub1(
        .A(A[4:1]),
        .B(B[4:1]),
        .B_in(0),
        .D(D[4:1]),
        .B_out(b4)
    );

    subtractor_4 sub2(
        .A(A[8:5]),
        .B(B[8:5]),
        .B_in(b4),
        .D(D[8:5]),
        .B_out(b8)
    );

    subtractor_4 sub3(
        .A(A[12:9]),
        .B(B[12:9]),
        .B_in(b8),
        .D(D[12:9]),
        .B_out(b12)
    );

    subtractor_4 sub4(
        .A(A[16:13]),
        .B(B[16:13]),
        .B_in(b12),
        .D(D[16:13]),
        .B_out(B_out)
    );
endmodule

module subtractor_4(A, B, B_in, D, B_out);
    input [4:1] A;        // 4-bit input A
    input [4:1] B;        // 4-bit input B
    input B_in;           // Borrow in
    output [4:1] D;       // 4-bit difference output
    output B_out;         // Borrow out

    wire p1, p2, p3, p4;  // Propagate signals
    wire g1, g2, g3, g4;  // Generate signals
    wire b1, b2, b3;      // Internal borrow signals

    // Instantiate full subtractors for each bit
    full_subtractor fs1(
        .A(A[1]),
        .B(B[1]),
        .B_in(B_in),
        .D(D[1]),
        .B_out(b1)
    );

    full_subtractor fs2(
        .A(A[2]),
        .B(B[2]),
        .B_in(b1),
        .D(D[2]),
        .B_out(b2)
    );

    full_subtractor fs3(
        .A(A[3]),
        .B(B[3]),
        .B_in(b2),
        .D(D[3]),
        .B_out(b3)
    );

    full_subtractor fs4(
        .A(A[4]),
        .B(B[4]),
        .B_in(b3),
        .D(D[4]),
        .B_out(B_out)
    );

    // Generate and propagate signals
    assign p1 = A[1] ^ B[1];
    assign g1 = ~A[1] & B[1];

    assign p2 = A[2] ^ B[2];
    assign g2 = ~A[2] & B[2];

    assign p3 = A[3] ^ B[3];
    assign g3 = ~A[3] & B[3];

    assign p4 = A[4] ^ B[4];
    assign g4 = ~A[4] & B[4];

endmodule

module full_subtractor(A, B, B_in, D, B_out);
    input A;              // Input A
    input B;              // Input B
    input B_in;           // Borrow in
    output D;             // Difference output
    output B_out;         // Borrow out

    assign D = A ^ B ^ B_in; // Difference calculation
    assign B_out = (~A & B) | ((~A | B) & B_in); // Borrow out calculation
endmodule