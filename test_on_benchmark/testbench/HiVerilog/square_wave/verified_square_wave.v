module verified_square_wave(
    input clk,
    input [7:0] freq,
    output wave_out
);

    wire count_enable;
    wire [7:0] count_value;

    // Instance of counter module
    counter cnt (
        .clk(clk),
        .enable(count_enable),
        .freq(freq),
        .count(count_value)
    );

    // Instance of wave generator module
    wave_generator wg (
        .clk(clk),
        .count(count_value),
        .freq(freq),
        .wave_out(wave_out)
    );

    // Control logic for enabling the counter
    assign count_enable = (freq > 0);

endmodule

module counter(
    input clk,
    input enable,
    input [7:0] freq,
    output reg [7:0] count
);

    initial begin
        count = 0;
    end

    always @(posedge clk) begin
        if (enable) begin
            if (count == freq - 1) begin
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule

module wave_generator(
    input clk,
    input [7:0] count,
    input [7:0] freq,
    output reg wave_out
);

    initial begin
        wave_out = 0;
    end

    always @(posedge clk) begin
        if (count == freq - 1) begin
            wave_out <= ~wave_out;
        end
    end

endmodule