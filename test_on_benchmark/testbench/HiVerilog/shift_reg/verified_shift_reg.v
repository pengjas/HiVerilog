module verified_shift_reg (
    input clk,
    input d,
    output q
);
    wire q0, q1; // Intermediate outputs from flip-flops

    // Instantiate three D flip-flops
    my_dff u0 (.clk(clk), .d(d), .q(q0));   // First flip-flop
    my_dff u1 (.clk(clk), .d(q0), .q(q1));  // Second flip-flop
    my_dff u2 (.clk(clk), .d(q1), .q(q));    // Third flip-flop

endmodule

module my_dff (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d; // On the rising edge of clk, assign d to q
    end
endmodule