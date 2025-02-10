module verified_multiplier_32bit(A, B, P);
    input [31:0] A;  // 32-bit input operand A
    input [31:0] B;  // 32-bit input operand B
    output [63:0] P; // 64-bit output product P

    wire [31:0] partials[31:0]; // Partial products
    wire [63:0] sum[31:0];       // Sums of partial products

    // Generate partial products
    genvar i, j;
    generate
        for (i = 0; i < 32; i = i + 1) begin : partial_product
            assign partials[i] = A & {32{B[i]}};
        end
    endgenerate

    // Add partial products
    assign sum[0] = {32'b0, partials[0]};
    generate
        for (j = 1; j < 32; j = j + 1) begin : add_partials
            adder_64 adder_inst (
                .A(sum[j-1]),
                .B({32'b0, partials[j]}),
                .S(sum[j])
            );
        end
    endgenerate

    assign P = sum[31]; // Final product

endmodule

module adder_64(A, B, S);
    input [63:0] A; // 64-bit input A
    input [63:0] B; // 64-bit input B
    output [63:0] S; // 64-bit output S

    assign S = A + B; // Simple addition
endmodule