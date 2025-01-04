module verified_freq_div (
    input CLK_in,
    input RST,
    output CLK_50,
    output CLK_10,
    output CLK_1
);

    // Submodule instances
    wire clk_50_out;
    wire clk_10_out;
    wire clk_1_out;

    clk_div_2 clk_div_50 (
        .CLK_in(CLK_in),
        .RST(RST),
        .CLK_out(clk_50_out)
    );

    clk_div_10 clk_div_10 (
        .CLK_in(CLK_in),
        .RST(RST),
        .CLK_out(clk_10_out)
    );

    clk_div_100 clk_div_1 (
        .CLK_in(CLK_in),
        .RST(RST),
        .CLK_out(clk_1_out)
    );

    // Assign outputs
    assign CLK_50 = clk_50_out;
    assign CLK_10 = clk_10_out;
    assign CLK_1 = clk_1_out;

endmodule

// Submodule for 50 MHz clock generation
module clk_div_2 (
    input CLK_in,
    input RST,
    output reg CLK_out
);
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_out <= 1'b0;
        end else begin
            CLK_out <= ~CLK_out;
        end
    end
endmodule

// Submodule for 10 MHz clock generation
module clk_div_10 (
    input CLK_in,
    input RST,
    output reg CLK_out
);
    reg [3:0] cnt;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_out <= 1'b0;
            cnt <= 0;
        end else if (cnt == 4) begin
            CLK_out <= ~CLK_out;
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end
    end
endmodule

// Submodule for 1 MHz clock generation
module clk_div_100 (
    input CLK_in,
    input RST,
    output reg CLK_out
);
    reg [6:0] cnt;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_out <= 1'b0;
            cnt <= 0;
        end else if (cnt == 49) begin
            CLK_out <= ~CLK_out;
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end
    end
endmodule