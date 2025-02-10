// Instruction types
`define ADD_INST 2'b00
`define SUB_INST 2'b01
module verified_stagepipe3(
    input clk,
    input rst,
    input [31:0] instr_mem [0:31],
    input [31:0] reg_file [0:31],
    output [31:0] out_reg_file  
);
wire [31:0] inst;
wire [31:0] result;

fetch_stage fetch (.clk(clk), .inst(inst), .rst(rst), .instr_mem_in(instr_mem));
execute_stage execute (
  .clk(clk),
  .inst(inst),
  .reg_file(reg_file),
  .result(result)
);
writeback_stage writeback (
  .clk(clk),
  .result(result),
  .reg_file(out_reg_file)
);
endmodule

  
// Pipeline stages 
module fetch_stage(
  input clk,
  output reg [31:0] inst,
  input [31:0] instr_mem_in [0:31],
  input rst
);
  reg [31:0] pc;
  // Fetch logic
  always @(posedge clk or posedge rst) begin
    // Fetch next instruction
    if(rst)
    	begin
    	pc <= 0;
    	inst <= 0;
    	end
    else 
    	begin
    	inst <= instr_mem_in[pc>>2];
    	pc <= pc + 4;
    	end
  end
endmodule
module execute_stage(
  input clk,
  input [31:0] inst,
  input [31:0] reg_file [0:31],
  output reg [31:0] result
);

  // Decode and read operands
  always @(posedge clk) begin
    case(inst[31:30])
      `ADD_INST: begin
        result<= reg_file[inst[29:25]]+reg_file[inst[24:20]];
      end
      `SUB_INST: begin
        result <= reg_file[inst[29:25]]-reg_file[inst[24:20]];
      end
      default: begin
        result <= 0;
      end
    endcase
  end
endmodule 
module writeback_stage(
  input clk,
  input [31:0] result,
  // Writeback
  output reg [31:0] reg_file 
);
  always @(posedge clk) begin
    reg_file <= result;
  end
endmodule
