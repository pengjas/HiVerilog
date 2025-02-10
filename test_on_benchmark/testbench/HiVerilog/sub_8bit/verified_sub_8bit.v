module verified_sub_8bit(A, B, D, B_out);
    input [7:0] A;      // 8-bit input operand A
    input [7:0] B;      // 8-bit input operand B
    output [7:0] D;     // 8-bit output representing the difference A - B
    output B_out;       // Borrow output

    wire [7:0] B_complement;
    wire borrow;

    // Generate 2's complement of B
    assign B_complement = ~B + 1;

    // Instantiate the adder module to perform A + (~B + 1)
    adder_8bit adder_inst(
        .A(A),
        .B(B_complement),
        .D(D),
        .Cout(borrow)
    );

    // Borrow output logic
    assign B_out = borrow;

endmodule

module adder_8bit(A, B, D, Cout);
    input [7:0] A;      // 8-bit input operand A
    input [7:0] B;      // 8-bit input operand B
    output [7:0] D;     // 8-bit output representing the sum
    output Cout;        // Carry out (borrow in this case)

    wire [7:0] sum;
    wire carry[0:7];    // Intermediate carry wires

    // Full adder instances
    full_adder FA0(.A(A[0]), .B(B[0]), .Cin(1'b0), .Sum(sum[0]), .Cout(carry[0]));
    full_adder FA1(.A(A[1]), .B(B[1]), .Cin(carry[0]), .Sum(sum[1]), .Cout(carry[1]));
    full_adder FA2(.A(A[2]), .B(B[2]), .Cin(carry[1]), .Sum(sum[2]), .Cout(carry[2]));
    full_adder FA3(.A(A[3]), .B(B[3]), .Cin(carry[2]), .Sum(sum[3]), .Cout(carry[3]));
    full_adder FA4(.A(A[4]), .B(B[4]), .Cin(carry[3]), .Sum(sum[4]), .Cout(carry[4]));
    full_adder FA5(.A(A[5]), .B(B[5]), .Cin(carry[4]), .Sum(sum[5]), .Cout(carry[5]));
    full_adder FA6(.A(A[6]), .B(B[6]), .Cin(carry[5]), .Sum(sum[6]), .Cout(carry[6]));
    full_adder FA7(.A(A[7]), .B(B[7]), .Cin(carry[6]), .Sum(sum[7]), .Cout(Cout));

    // Assign the sum to output
    assign D = sum;

endmodule

module full_adder(A, B, Cin, Sum, Cout);
    input A;       // Input A
    input B;       // Input B
    input Cin;     // Carry input
    output Sum;    // Sum output
    output Cout;   // Carry output

    assign Sum = A ^ B ^ Cin;                  // Sum calculation
    assign Cout = (A & B) | (Cin & (A ^ B));  // Carry calculation
endmodule