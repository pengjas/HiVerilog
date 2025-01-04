module verified_instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    // Submodule for instruction storage
    wire [7:0] ins_p1_out, ins_p2_out;

    instruction_storage ins1 (
        .clk(clk),
        .rst(rst),
        .fetch(fetch),
        .data(data),
        .ins_out(ins_p1_out),
        .fetch_code(2'b01) // Fetch from register
    );

    instruction_storage ins2 (
        .clk(clk),
        .rst(rst),
        .fetch(fetch),
        .data(data),
        .ins_out(ins_p2_out),
        .fetch_code(2'b10) // Fetch from RAM/ROM
    );

    // Output assignments
    assign ins = ins_p1_out[7:5]; // High 3 bits, instructions
    assign ad1 = ins_p1_out[4:0];  // Low 5 bits, register address
    assign ad2 = ins_p2_out;        // Full 8-bit data from second source

endmodule

// Submodule for instruction storage
module instruction_storage (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [7:0] ins_out,
    input [1:0] fetch_code // Code to distinguish fetch sources
);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_out <= 8'd0; // Reset output
        end else begin
            if (fetch == fetch_code) begin
                ins_out <= data; // Capture data if fetch code matches
            end else begin
                ins_out <= ins_out; // Retain previous value
            end
        end
    end

endmodule