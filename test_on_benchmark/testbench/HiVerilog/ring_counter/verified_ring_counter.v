module verified_ring_counter (
    input wire clk,
    input wire reset,
    output wire [7:0] out
);

    wire [7:0] state;

    // Submodule for state initialization
    state_init init (
        .clk(clk),
        .reset(reset),
        .state(state)
    );

    // Submodule for state transition
    state_transition transition (
        .clk(clk),
        .reset(reset),
        .state_in(state),
        .state_out(out)
    );

endmodule

// Submodule for state initialization
module state_init (
    input wire clk,
    input wire reset,
    output reg [7:0] state
);

    always @ (posedge clk or posedge reset) begin
        if (reset)
            state <= 8'b0000_0001; 
    end

endmodule

// Submodule for state transition
module state_transition (
    input wire clk,
    input wire reset,
    input wire [7:0] state_in,
    output reg [7:0] state_out
);

    always @ (posedge clk) begin
        if (!reset)
            state_out <= {state_in[6:0], state_in[7]}; 
    end

endmodule