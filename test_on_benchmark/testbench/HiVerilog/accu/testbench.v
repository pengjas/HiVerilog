`timescale  1ns / 1ps

module testbench();


parameter PERIOD  = 10;
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   [7:0]  data_in                       = 0 ;
reg   valid_in                             = 0 ;

wire  valid_out                              ;
wire  [9:0]  data_out                       ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

accu  uut (
    .clk                     ( clk             ),
    .rst_n                   ( rst_n           ),
    .data_in                 ( data_in   [7:0] ),
    .valid_in                ( valid_in        ),

    .valid_out               ( valid_out       ),
    .data_out                ( data_out  [9:0] )
);

initial
begin
    #(PERIOD*(1-0.01)); 
    #(PERIOD)   data_in = 8'd1;valid_in = 1;
    #(PERIOD)   data_in = 8'd2;
    #(PERIOD)   data_in = 8'd3;
    #(PERIOD)   data_in = 8'd14;

	#(3*PERIOD)  rst_n = 0;
	#(PERIOD)   rst_n = 1;

     data_in = 8'd5;
    #(PERIOD)   data_in = 8'd2;
    #(PERIOD)   data_in = 8'd103;
    #(PERIOD)   data_in = 8'd4;

	#(3*PERIOD)   rst_n = 0;
	#(PERIOD)   rst_n = 1;

    		     data_in = 8'd5;
    #(PERIOD)   data_in = 8'd6;
    #(PERIOD)   data_in = 8'd3;
    #(PERIOD)   data_in = 8'd54;
    #(PERIOD*2);
end

reg [9:0] result [0:2];
initial begin
    result[0] = 9'd20;
    result[1] = 9'd114;
    result[2] = 9'd68;
end

integer i;
integer casenum = 0;
integer error = 0;

initial begin
forever begin
        @(posedge valid_out)
			#(PERIOD/10);
            error = (data_out == result[casenum]) ? error : error + 1;
			if (data_out!=result[casenum]) begin
				$display("errror case: case %d", casenum);
				$display("data_out: %d", data_out);
				$display("result:%d", result[casenum]);
			end
			casenum = casenum + 1;
			if(error==0 && casenum==3)
				begin
					$display("===========Your Design Passed===========");
					$finish();
        		end
			else if(casenum==3)
				begin
					$display("===========Error===========");
					$finish();
				end
	#10;
end
end

// initial begin
// 	$fsdbDumpfile("./testresult/tb.fsdb");
// 	$fsdbDumpvars(0,testbench);
// 	$display("testbench");
// 	#1000;
// 	$finish();
// end


endmodule
