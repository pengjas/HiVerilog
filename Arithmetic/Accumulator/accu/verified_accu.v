`timescale 1ns/1ps

module verified_accu (
    input               clk,
    input               rst_n,
    input       [7:0]   data_in,
    input               valid_in,

    output              valid_out,
    output      [9:0]   data_out
);

    wire [2:0] count;
    wire add_cnt;
    wire end_cnt;
    wire ready_add;
    wire [9:0] data_out_reg;

    // Instantiate the counter module
    counter u_counter (
        .clk(clk),
        .rst_n(rst_n),
        .add_cnt(add_cnt),
        .end_cnt(end_cnt),
        .count(count)
    );

    // Instantiate the data accumulation module
    data_accumulator u_data_accumulator (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .add_cnt(add_cnt),
		.count(count),
        .data_out(data_out_reg)
    );

    // Instantiate the valid output module
    valid_output u_valid_output (
        .clk(clk),
        .rst_n(rst_n),
        .end_cnt(end_cnt),
        .valid_out(valid_out)
    );

    assign add_cnt = ready_add;
    assign end_cnt = ready_add && (count == 'd4);
    assign ready_add = valid_in;
    assign data_out = data_out_reg;

endmodule

module counter (
    input               clk,
    input               rst_n,
    input               add_cnt,
    input               end_cnt,
    output reg [2:0]   count
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
        end
        else if (end_cnt||count=='d4) begin
            count <= 0;
        end
        else if (add_cnt) begin
            count <= count + 1;
        end
    end

endmodule

module data_accumulator (
    input               clk,
    input               rst_n,
    input       [7:0]   data_in,
    input               add_cnt,
	input 		[2:0]  count,
    output reg [9:0]   data_out
);

    reg [9:0] data_out_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out_reg <= 0;
        end
        else if (add_cnt && (count == 'd0)) begin
            data_out_reg <= data_in;
        end
        else if (add_cnt) begin
            data_out_reg <= data_out_reg + data_in;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
        end
        else begin
            data_out <= data_out_reg;
        end
    end

endmodule


module valid_output (
    input               clk,
    input               rst_n,
    input               end_cnt,
    output reg         valid_out
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 0;
        end
        else 
            valid_out <= end_cnt;
    end

endmodule
