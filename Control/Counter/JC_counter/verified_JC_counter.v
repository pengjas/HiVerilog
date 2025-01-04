`timescale 1ns/1ns

// Main module for the Johnson Counter
module JC_counter(
    input                clk,
    input                rst_n,
    output [63:0]       Q
);
    wire [63:0] Q_internal;

    // Instance of the register module
    JC_register reg_inst (
        .clk(clk),
        .rst_n(rst_n),
        .Q(Q_internal)
    );

    // Instance of the logic module to determine the next state
    JC_logic logic_inst (
        .clk(clk),
        .rst_n(rst_n),
        .Q(Q_internal),
        .Q_next(Q)
    );

endmodule

// Submodule for the register to store the current state of the counter
module JC_register(
    input                clk,
    input                rst_n,
    output reg [63:0]   Q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            Q <= 64'd0;
    end
endmodule

// Submodule for the logic that determines the next state of the counter
module JC_logic(
    input                clk,
    input                rst_n,
    input [63:0]        Q,
    output reg [63:0]   Q_next
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            Q_next <= 64'd0;
        else if (!Q[0]) 
            Q_next <= {1'b1, Q[63:1]};
        else 
            Q_next <= {1'b0, Q[63:1]};
    end
endmodule