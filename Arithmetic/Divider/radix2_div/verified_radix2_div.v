`timescale 1ns/1ps

module verified_radix2_div(
    input wire clk,
    input wire rst,
    input wire [7:0] dividend,    
    input wire [7:0] divisor,    
    input wire sign,       
    input wire opn_valid,   
    output reg res_valid,   
    input wire res_ready,   
    output wire [15:0] result
);

    wire [7:0] dividend_abs;
    wire [8:0] neg_divisor;
    wire [15:0] sr;
    wire [8:0] mux_result;
    wire co;
    wire [3:0] cnt;
    wire start_cnt;

    // Instantiate modules
    abs_value abs_dividend (
        .sign(sign),
        .value(dividend),
        .abs_value(dividend_abs)
    );

    neg_value neg_divisor_mod (
        .sign(sign),
        .value(divisor),
        .neg_value(neg_divisor)
    );

    divider_control ctrl (
        .clk(clk),
        .rst(rst),
        .opn_valid(opn_valid),
        .start_cnt(start_cnt),
        .cnt(cnt),
        .sr(sr),
        .dividend_abs(dividend_abs),
        .neg_divisor(neg_divisor),
        .result(result),
        .mux_result(mux_result),
        .co(co)
    );

    // Result management
    result_management res_mgmt (
        .clk(clk),
        .rst(rst),
        .cnt(cnt),
        .res_valid(res_valid),
        .res_ready(res_ready)
    );

endmodule

// Module to compute absolute value of dividend
module abs_value(
    input wire sign,
    input wire [7:0] value,
    output wire [7:0] abs_value
);
    assign abs_value = (sign & value[7]) ? ~value + 1'b1 : value;
endmodule

// Module to compute negative value of divisor
module neg_value(
    input wire sign,
    input wire [7:0] value,
    output wire [8:0] neg_value
);
    assign neg_value = (sign & value[7]) ? {1'b1, value} : ~{1'b0, value} + 1'b1;
endmodule

// Module for the control logic of the division process
module divider_control(
    input wire clk,
    input wire rst,
    input wire opn_valid,
    output reg start_cnt,
    output reg [3:0] cnt,
    output reg [15:0] sr,
    input wire [7:0] dividend_abs,
    input wire [8:0] neg_divisor,
    output wire [15:0] result,
    output wire [8:0] mux_result,
    output wire co
);
    
    always @(posedge clk) begin
        if (rst) begin
            sr <= 0;
            cnt <= 0;
            start_cnt <= 1'b0;
        end else if (~start_cnt & opn_valid) begin
            cnt <= 1;
            start_cnt <= 1'b1;
            sr <= {7'b0, dividend_abs, 1'b0}; 
        end else if (start_cnt) begin
            if (cnt[3]) begin
                cnt <= 0;
                start_cnt <= 1'b0;
                sr[15:8] <= mux_result[7:0]; // Update quotient
                sr[0] <= co; // Update remainder
            end else begin
                cnt <= cnt + 1;
                sr <= {mux_result[6:0], sr[7:1], co, 1'b0}; // Shift and update
            end
        end
    end

    assign {co, mux_result} = {1'b0, sr[15:8]} + neg_divisor; // Addition to check carry

    assign result = {sr[15:8], sr[7:0]}; // Concatenate remainder and quotient

endmodule

// Module to manage result validity
module result_management(
    input wire clk,
    input wire rst,
    input wire [3:0] cnt,
    output reg res_valid,
    input wire res_ready
);
    always @(posedge clk) begin
        res_valid <= rst ? 1'b0 :
                     cnt[3] ? 1'b1 :
                     res_ready ? 1'b0 : res_valid;
    end
endmodule