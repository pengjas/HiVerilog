module fixed_point_subtractor #(
    parameter Q = 15,
    parameter N = 32
)
(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Internal signals
wire [N-1:0] sum;
wire same_sign;
wire [N-1:0] sub_result;

// Instantiate submodules
sign_detector #(.N(N)) u_sign_detector (
    .a(a),
    .b(b),
    .same_sign(same_sign)
);

adder #(.N(N)) u_adder (
    .a(a[N-2:0]),
    .b(b[N-2:0]),
    .result(sum)
);

subtractor #(.N(N)) u_subtractor (
    .a(a[N-2:0]),
    .b(b[N-2:0]),
    .result(sub_result)
);

// Logic to determine the output based on sign
assign c = (same_sign) ? {a[N-1], sub_result[N-2:0]} : 
           (a[N-1] == 0 && b[N-1] == 1) ? ((a[N-2:0] > b[N-2:0]) ? {1'b0, sum[N-2:0]} : {1'b1, sum[N-2:0]}) :
           (a[N-1] == 1 && b[N-1] == 0) ? ((a[N-2:0] > b[N-2:0]) ? {1'b1, sum[N-2:0]} : {1'b0, sum[N-2:0]}) : 
           0;

endmodule

// Sign detector module
module sign_detector #(
    parameter N = 32
)
(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg same_sign
);
    always @(*) begin
        same_sign = (a[N-1] == b[N-1]);
    end
endmodule

// Adder module
module adder #(
    parameter N = 32
)
(
    input [N-2:0] a,
    input [N-2:0] b,
    output [N-2:0] result
);
    assign result = a + b;
endmodule

// Subtractor module
module subtractor #(
    parameter N = 32
)
(
    input [N-2:0] a,
    input [N-2:0] b,
    output reg [N-2:0] result
);
    always @(*) begin
        if (a >= b)
            result = a - b;
        else
            result = b - a;
    end
endmodule