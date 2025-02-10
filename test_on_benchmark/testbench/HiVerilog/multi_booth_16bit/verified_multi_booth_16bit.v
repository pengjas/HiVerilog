`timescale 1ns / 1ps

module verified_multi_booth_16bit (
    output [31:0] p,
    output rdy,
    input clk,
    input reset,
    input [15:0] a,
    input [15:0] b
);
    // Internal signals
    wire [31:0] multiplicand;
    wire [31:0] multiplier;
    wire [4:0] ctr;
    
    reg [31:0] p_reg;
    reg rdy_reg;
    
    // Instantiate the registers
    reg_file reg_file_inst (
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .multiplicand(multiplicand),
        .multiplier(multiplier)
    );
    
    // Instantiate the counter
    counter counter_inst (
        .clk(clk),
        .reset(reset),
        .ctr(ctr)
    );

    // Booth multiplier logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rdy_reg <= 0;
            p_reg <= 0;
        end else begin
            if (ctr < 16) begin
                // Shift multiplicand
                p_reg <= p_reg + (multiplier[ctr] ? multiplicand : 0);
            end else begin
                rdy_reg <= 1;
            end
        end
    end

    assign p = p_reg;
    assign rdy = rdy_reg;

endmodule

module reg_file (
    input clk,
    input reset,
    input [15:0] a,
    input [15:0] b,
    output reg [31:0] multiplicand,
    output reg [31:0] multiplier
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign-extend and initialize registers
            multiplicand <= {16'b0, b};  // 16-bit b
            multiplier <= {16'b0, a};    // 16-bit a
        end
    end
endmodule

module counter (
    input clk,
    input reset,
    output reg [4:0] ctr
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ctr <= 0;
        end else begin
            if (ctr < 16) begin
                ctr <= ctr + 1;
            end
        end
    end
endmodule