module verified_up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output wire [15:0] count
);

    wire [15:0] next_count;

    // Instantiate the counter logic
    counter_logic u_counter_logic (
        .clk(clk),
        .reset(reset),
        .up_down(up_down),
        .current_count(count),
        .next_count(next_count)
    );

    // Instantiate the register to hold the count value
    counter_register u_counter_register (
        .clk(clk),
        .reset(reset),
        .next_count(next_count),
        .current_count(count)
    );

endmodule

module counter_logic (
    input wire clk,
    input wire reset,
    input wire up_down,
    input wire [15:0] current_count,
    output reg [15:0] next_count
);

    always @(*) begin
        if (reset) begin
            next_count = 16'b0; 
        end else begin
            if (up_down) begin
                // Increment the counter if up_down is high
                if (current_count == 16'b1111_1111_1111_1111) begin
                    next_count = 16'b0; 
                end else begin
                    next_count = current_count + 1; 
                end
            end else begin
                // Decrement the counter if up_down is low
                if (current_count == 16'b0) begin
                    next_count = 16'b1111_1111_1111_1111; 
                end else begin
                    next_count = current_count - 1; 
                end
            end
        end
    end

endmodule

module counter_register (
    input wire clk,
    input wire reset,
    input wire [15:0] next_count,
    output reg [15:0] current_count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_count <= 16'b0; 
        end else begin
            current_count <= next_count; 
        end
    end

endmodule