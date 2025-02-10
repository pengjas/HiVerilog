module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output [31:0] c
);

// Intermediate wire to hold the multiplication result
wire [63:0] mult_result;
wire [31:0] accumulated_value;

// Instantiating the multiplier module
multiplier u_multiplier (
    .a(a),
    .b(b),
    .result(mult_result)
);

// Instantiating the accumulator module
accumulator u_accumulator (
    .clk(clk),
    .rst(rst),
    .new_value(mult_result[31:0]), // Take lower 32 bits for accumulation
    .current_value(accumulated_value)
);

// Assigning the accumulated value to the output
assign c = accumulated_value;

endmodule

// Multiplier module
module multiplier(
    input [31:0] a,
    input [31:0] b,
    output [63:0] result
);
    assign result = a * b;
endmodule

// Accumulator module
module accumulator(
    input clk,
    input rst,
    input [31:0] new_value,
    output reg [31:0] current_value
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_value <= 0;
        end else begin
            current_value <= current_value + new_value;
        end
    end
endmodule