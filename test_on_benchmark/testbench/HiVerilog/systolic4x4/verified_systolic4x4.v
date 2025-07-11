module verified_systolic4x4(
  input clk,
  input rst,
  input [15:0] weight [0:3] [0:3],
  input [15:0] inputt [0:15],
  output [31:0] outputt [0:15]  
);
// Instantiate 16 PEs 
PE pe00(.clk(clk), .rst(rst), .a(inputt[0]), .b(weight[0][0]), .c(outputt[0]));
PE pe01(.clk(clk), .rst(rst), .a(inputt[1]), .b(weight[0][1]), .c(outputt[1]));
PE pe02(.clk(clk), .rst(rst), .a(inputt[2]), .b(weight[0][2]), .c(outputt[2]));
PE pe03(.clk(clk), .rst(rst), .a(inputt[3]), .b(weight[0][3]), .c(outputt[3]));
PE pe04(.clk(clk), .rst(rst), .a(inputt[4]), .b(weight[1][0]), .c(outputt[4]));
PE pe05(.clk(clk), .rst(rst), .a(inputt[5]), .b(weight[1][1]), .c(outputt[5]));
PE pe06(.clk(clk), .rst(rst), .a(inputt[6]), .b(weight[1][2]), .c(outputt[6]));
PE pe07(.clk(clk), .rst(rst), .a(inputt[7]), .b(weight[1][3]), .c(outputt[7]));
PE pe08(.clk(clk), .rst(rst), .a(inputt[8]), .b(weight[2][0]), .c(outputt[8]));
PE pe09(.clk(clk), .rst(rst), .a(inputt[9]), .b(weight[2][1]), .c(outputt[9]));
PE pe10(.clk(clk), .rst(rst), .a(inputt[10]), .b(weight[2][2]), .c(outputt[10]));
PE pe11(.clk(clk), .rst(rst), .a(inputt[11]), .b(weight[2][3]), .c(outputt[11]));
PE pe12(.clk(clk), .rst(rst), .a(inputt[12]), .b(weight[3][0]), .c(outputt[12]));
PE pe13(.clk(clk), .rst(rst), .a(inputt[13]), .b(weight[3][1]), .c(outputt[13]));
PE pe14(.clk(clk), .rst(rst), .a(inputt[14]), .b(weight[3][2]), .c(outputt[14]));
PE pe15(.clk(clk), .rst(rst), .a(inputt[15]), .b(weight[3][3]), .c(outputt[15]));

endmodule

module PE (
  input clk,
  input rst,
  input [15:0] a,
  input [15:0] b,
  output[31:0] c
);
  reg [31:0] r;
  always @(posedge clk or posedge rst) begin
    if (rst)
      r <= 0;
    else
      r <= r + (a * b);
  end
  assign c = r;
endmodule