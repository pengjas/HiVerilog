////Testbench
module testbench();

  reg [15:0] a,b;
  reg Cin;
  wire [15:0] y;
  wire Co;
  wire [16:0] tb_sum;
  wire tb_co;

  assign tb_sum = a + b;
  assign tb_co = tb_sum[16];

  integer i;
  integer error = 0;

  initial begin
      for (i = 0; i < 100; i = i + 1) begin
          a = {$random};
          b = {$random};
          Cin = 0;

          #10;
          error = (y !== tb_sum[15:0] || Co !== tb_co) ? error + 1 : error;
      end

      if (error == 0) begin
          $display("===========Your Design Passed===========");
      end
      else begin
          $display("===========Test completed with %d / 100 failures===========", error);
      end
  end

  adder_16bit_csa uut(.a(a), .b(b),.cin(Cin),.sum(y),.cout(Co));

// initial begin
//   a=0; b=0; cin=0;
//   #10 a=16'd0; b=16'd0; cin=1'd1;
//   if (sum != 16'd1) $error("Test failed for a=0, b=0, cin=1");
//   #10 a=16'd14; b=16'd1; cin=1'd1;
//   if (sum != 16'd16) $error("Test failed for a=14, b=1, cin=1");
//   #10 a=16'd5; b=16'd0; cin=1'd0;
//   if (sum != 16'd5) $error("Test failed for a=5, b=0, cin=0");
//   #10 a=16'd999; b=16'd0; cin=1'd1;
//   if (sum != 16'd1000) $error("Test failed for a=999, b=0, cin=1");
//   $display("All tests passed");
// end

// initial
//   $monitor( "A=%d, B=%d, Cin= %d, Sum=%d, Cout=%d", a,b,cin,sum,cout);

endmodule