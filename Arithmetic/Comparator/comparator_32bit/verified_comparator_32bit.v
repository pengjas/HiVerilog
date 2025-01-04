module verified_comparator_32bit(
    input [31:0] A,   // First 32-bit input operand
    input [31:0] B,   // Second 32-bit input operand
    output A_greater, 
    output A_equal,   
    output A_less     
);

    wire [31:0] diff;  
    wire cout;       

    // Instantiate the 32-bit subtractor
    subtractor_32bit sub_inst (
        .A(A),
        .B(B),
        .diff(diff),
        .cout(cout)
    );

    // Determine the comparison outputs
    assign A_greater = (~cout && diff != 32'b0);
    assign A_equal = (A == B);
    assign A_less = cout;

endmodule

module subtractor_32bit(
    input [31:0] A,   // First operand
    input [31:0] B,   // Second operand
    output [31:0] diff, // Difference output
    output cout       // Carry output (borrow for subtraction)
);

    // Perform the subtraction
    assign {cout, diff} = A - B;

endmodule