module fixed_point_adder #(
    parameter Q = 15,
    parameter N = 32
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

wire [N-1:0] add_res;
wire [N-1:0] sub_res;
wire add_sign, sub_sign;

// Submodule for addition
fixed_point_adder_add #(
    .Q(Q),
    .N(N)
) adder (
    .a(a),
    .b(b),
    .result(add_res),
    .result_sign(add_sign)
);

// Submodule for subtraction
fixed_point_adder_sub #(
    .Q(Q),
    .N(N)
) subtractor (
    .a(a),
    .b(b),
    .result(sub_res),
    .result_sign(sub_sign)
);

// Output logic to determine the final result
always @(*) begin
    if (a[N-1] == b[N-1]) begin
        // Both have the same sign
        c = {add_sign, add_res[N-2:0]};
    end else begin
        // Different signs, choose based on absolute values
        if (a[N-1] == 0 && b[N-1] == 1) begin
            c = {sub_sign, sub_res[N-2:0]};
        end else if (a[N-1] == 1 && b[N-1] == 0) begin
            c = {sub_sign, sub_res[N-2:0]};
        end
    end
end

endmodule

module fixed_point_adder_add #(
    parameter Q = 15,
    parameter N = 32
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] result,
    output reg result_sign
);

always @(*) begin
    result[N-2:0] = a[N-2:0] + b[N-2:0];
    result_sign = a[N-1]; // Keep the sign same as inputs
end

endmodule

module fixed_point_adder_sub #(
    parameter Q = 15,
    parameter N = 32
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] result,
    output reg result_sign
);

always @(*) begin
    if (a[N-2:0] > b[N-2:0]) begin
        result[N-2:0] = a[N-2:0] - b[N-2:0];
        result_sign = 0; // Positive result
    end else begin
        result[N-2:0] = b[N-2:0] - a[N-2:0];
        result_sign = 1; // Negative result
    end
end

endmodule