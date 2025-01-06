module verified_signal_generator (
    input clk,
    input rst_n,
    output [4:0] wave
);

    wire [1:0] state;
    reg [4:0] wave_reg;

    // State Control Module
    state_control state_inst (
        .clk(clk),
        .rst_n(rst_n),
        .wave(wave_reg),
        .state(state)
    );

    // Waveform Generation Module
    waveform_gen wave_inst (
        .clk(clk),
        .rst_n(rst_n),
        .state(state),
        .wave(wave_reg)
    );

    assign wave = wave_reg;

endmodule

// State Control Module
module state_control (
    input clk,
    input rst_n,
    input [4:0] wave,
    output reg [1:0] state
);

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 2'b00;
        end else begin
            case (state)
                2'b00:
                    if (wave == 5'b11111) // 31
                        state <= 2'b01;
                2'b01:
                    if (wave == 5'b00000) // 0
                        state <= 2'b00;
            endcase
        end
    end

endmodule

// Waveform Generation Module
module waveform_gen (
    input clk,
    input rst_n,
    input [1:0] state,
    output reg [4:0] wave
);

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 5'b0;
        end else begin
            case (state)
                2'b00:
                    wave <= wave + 1;
                2'b01:
                    wave <= wave - 1;
            endcase
        end
    end

endmodule