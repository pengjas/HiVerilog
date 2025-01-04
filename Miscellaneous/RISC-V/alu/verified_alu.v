`timescale 1ns / 1ps

module modular_alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output flag
);

    // Submodule instances
    wire [32:0] add_result, sub_result, and_result, or_result, xor_result, nor_result;
    wire [31:0] slt_result, sltu_result, sll_result, srl_result, sra_result, lui_result;

    // Instantiate arithmetic operations
    adder add(.a(a), .b(b), .result(add_result));
    adder_unsigned addu(.a(a), .b(b), .result(add_result));
    subtractor sub(.a(a), .b(b), .result(sub_result));
    and_gate and1(.a(a), .b(b), .result(and_result));
    or_gate or1(.a(a), .b(b), .result(or_result));
    xor_gate xor1(.a(a), .b(b), .result(xor_result));
    nor_gate nor1(.a(a), .b(b), .result(nor_result));

    // Instantiate comparison operations
    slt slt_inst(.a(a), .b(b), .result(slt_result));
    sltu sltu_inst(.a(a), .b(b), .result(sltu_result));

    // Instantiate shift operations
    shift_left sll(.a(b), .shift_amount(a), .result(sll_result));
    shift_right srl(.a(b), .shift_amount(a), .result(srl_result));
    shift_arithmetic sra(.a(b), .shift_amount(a), .result(sra_result));
    lui_module lui_inst(.a(a), .result(lui_result));

    // Result selection based on aluc
    reg [31:0] res;
    assign r = res;

    always @(*) begin
        case (aluc)
            6'b100000: res = add_result[31:0];   // ADD
            6'b100001: res = add_result[31:0];   // ADDU
            6'b100010: res = sub_result[31:0];   // SUB
            6'b100011: res = sub_result[31:0];   // SUBU
            6'b100100: res = and_result[31:0];   // AND
            6'b100101: res = or_result[31:0];    // OR
            6'b100110: res = xor_result[31:0];   // XOR
            6'b100111: res = nor_result[31:0];   // NOR
            6'b101010: res = slt_result;          // SLT
            6'b101011: res = sltu_result;         // SLTU
            6'b000000: res = sll_result;          // SLL
            6'b000010: res = srl_result;          // SRL
            6'b000011: res = sra_result;          // SRA
            6'b000100: res = sll_result;          // SLLV
            6'b000110: res = srl_result;          // SRLV
            6'b000111: res = sra_result;          // SRAV
            6'b001111: res = lui_result;          // LUI
            default: res = 32'bz;                 // Default case
        endcase
    end

    // Flags generation
    assign zero = (res == 32'b0);
    assign carry = add_result[32]; // Example for carry detection
    assign negative = res[31];
    assign overflow = (add_result[32] ^ add_result[31]) ? 1'b1 : 1'b0; // Adjust according to operations
    assign flag = (aluc == 6'b101010) ? (a < b) : (aluc == 6'b101011) ? (a < b) : 1'bz;

endmodule

// Submodules definition
module adder(
    input [31:0] a,
    input [31:0] b,
    output [32:0] result
);
    assign result = {1'b0, a} + {1'b0, b}; // 33-bit result for carry
endmodule

module adder_unsigned(
    input [31:0] a,
    input [31:0] b,
    output [32:0] result
);
    assign result = {1'b0, a} + {1'b0, b}; // 33-bit result for carry
endmodule

module subtractor(
    input [31:0] a,
    input [31:0] b,
    output [32:0] result
);
    assign result = {1'b0, a} - {1'b0, b}; // 33-bit result for borrow
endmodule

module and_gate(
    input [31:0] a,
    input [31:0] b,
    output [31:0] result
);
    assign result = a & b;
endmodule

module or_gate(
    input [31:0] a,
    input [31:0] b,
    output [31:0] result
);
    assign result = a | b;
endmodule

module xor_gate(
    input [31:0] a,
    input [31:0] b,
    output [31:0] result
);
    assign result = a ^ b;
endmodule

module nor_gate(
    input [31:0] a,
    input [31:0] b,
    output [31:0] result
);
    assign result = ~(a | b);
endmodule

module slt(
    input [31:0] a,
    input [31:0] b,
    output [31:0] result
);
    assign result = (a < b) ? 1 : 0;
endmodule

module sltu(
    input [31:0] a,
    input [31:0] b,
    output [31:0] result
);
    assign result = (a < b) ? 1 : 0;
endmodule

module shift_left(
    input [31:0] a,
    input [31:0] shift_amount,
    output [31:0] result
);
    assign result = a << shift_amount;
endmodule

module shift_right(
    input [31:0] a,
    input [31:0] shift_amount,
    output [31:0] result
);
    assign result = a >> shift_amount;
endmodule

module shift_arithmetic(
    input [31:0] a,
    input [31:0] shift_amount,
    output [31:0] result
);
    assign result = $signed(a) >>> shift_amount;
endmodule

module lui_module(
    input [31:0] a,
    output [31:0] result
);
    assign result = {a[15:0], 16'b0};
endmodule