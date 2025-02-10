module verified_freq_divbyodd(
    input clk,
    input rst_n,
    output clk_div
);
    // Parameter for the odd divisor
    parameter NUM_DIV = 5;

    wire clk_div1, clk_div2;
    wire [2:0] cnt1, cnt2; // 3-bit counters

    // Instantiate the positive edge counter
    pos_edge_counter #(.NUM_DIV(NUM_DIV)) u_pos_counter (
        .clk(clk),
        .rst_n(rst_n),
        .cnt(cnt1),
        .clk_div(clk_div1)
    );

    // Instantiate the negative edge counter
    neg_edge_counter #(.NUM_DIV(NUM_DIV)) u_neg_counter (
        .clk(clk),
        .rst_n(rst_n),
        .cnt(cnt2),
        .clk_div(clk_div2)
    );

    // Combine the divided clocks
    assign clk_div = clk_div1 | clk_div2;

endmodule

module pos_edge_counter(
    input clk,
    input rst_n,
    output reg [2:0] cnt,
    output reg clk_div
);
    parameter NUM_DIV = 5;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div <= 1'b1; // Initial state
        end else begin
            if (cnt < NUM_DIV - 1) begin
                cnt <= cnt + 1'b1;
            end else begin
                cnt <= 0;
            end
            
            if (cnt < NUM_DIV / 2) begin
                clk_div <= 1'b1;
            end else begin
                clk_div <= 1'b0;
            end
        end
    end
endmodule

module neg_edge_counter(
    input clk,
    input rst_n,
    output reg [2:0] cnt,
    output reg clk_div
);
    parameter NUM_DIV = 5;

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div <= 1'b1; // Initial state
        end else begin
            if (cnt < NUM_DIV - 1) begin
                cnt <= cnt + 1'b1;
            end else begin
                cnt <= 0;
            end
            
            if (cnt < NUM_DIV / 2) begin
                clk_div <= 1'b1;
            end else begin
                clk_div <= 1'b0;
            end
        end
    end
endmodule