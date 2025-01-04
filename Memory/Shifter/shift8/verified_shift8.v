module verified_shift8 (
    input clk,
    input [7:0] d,
    input [1:0] sel,
    output reg [7:0] q
);
    wire [7:0] q0, q1, q2;

    // Instantiating three D flip-flops
    my_dff8 u0 ( .clk(clk), .d(d), .q(q0) );
    my_dff8 u1 ( .clk(clk), .d(q0), .q(q1) );
    my_dff8 u2 ( .clk(clk), .d(q1), .q(q2) );

    // Multiplexer to select output based on sel
    always @(*) begin
        case(sel)
            2'b00: q = d;      // No delay
            2'b01: q = q0;     // 1 cycle delay
            2'b10: q = q1;     // 2 cycles delay
            2'b11: q = q2;     // 3 cycles delay
            default: q = 8'b0; // Default case
        endcase
    end
endmodule

module my_dff8 (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);
    always @(posedge clk) begin
        q <= d; // D flip-flop behavior
    end
endmodule