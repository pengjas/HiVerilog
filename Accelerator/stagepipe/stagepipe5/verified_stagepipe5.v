// Instruction types
`define ADD_INST 2'b00
`define SUB_INST 2'b01

// Pipeline stages
module verified_stagepipe5(
  input clk,
  input rst,
  input [31:0] instr_mem [0:31],
  input [31:0] reg_file [0:31],
  output [31:0] res_reg_file [0:31]
);

// Pipeline signals
wire [31:0] inst, pc, op1, op2, result, mem_data;
wire [4:0] rs1, rs2, rd, rd1, rd2;
wire [1:0] op;

fetch_stage fetch (.clk(clk), .inst(inst), .rst(rst), .instr_mem_in(instr_mem));
decode_stage decode (
  .clk(clk),
  .inst(inst),
  .rs1(rs1),
  .rs2(rs2),
  .op(op),
  .rd(rd)
);
execute_stage execute (
  .clk(clk),
  .rs1(rs1),
  .rs2(rs2),
  .reg_file(reg_file),
  .op(op),
  .result(result),
  .rdin1(rd),
  .rdout1(rd1)
);
memory_stage memory(.clk(clk), .alu_result(result), .mem_data(mem_data), .rdin2(rd1), .rdout2(rd2));
writeback_stage writeback (
  .clk(clk),
  .mem_data(mem_data),
  .rd(rd2),
  .reg_file(res_reg_file)
);
endmodule

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
module decode_stage(
  input clk,
  input [31:0] inst,
  output reg [4:0] rs1,
  output reg [4:0] rs2,
  output reg [1:0] op,
  output reg [4:0] rd

);
  always @(posedge clk) begin
    rs1 <= inst[29:25];
    rs2 <= inst[24:20];
    op <= inst[31:30];
    rd <= inst[4:0];
  end
endmodule
module execute_stage(
  input clk,
  input [4:0] rs1,
  input [4:0] rs2,
  input [31:0] reg_file [0:31],
  input [1:0] op,
  output reg [31:0] result,
  input [4:0] rdin1,//
  output reg [4:0] rdout1//
);

  always @(posedge clk) begin
    case(op)
      `ADD_INST: begin
        result<= reg_file[rs1] + reg_file[rs2];
      end
      `SUB_INST: begin
        result<= reg_file[rs1] - reg_file[rs2];
      end
      default: begin
        result <= 0;
      end
    endcase
    rdout1<=rdin1;//
  end
endmodule

module memory_stage(
  input clk,
  input [31:0] alu_result,
  output reg [31:0] mem_data,
  input [4:0] rdin2,//
  output reg [4:0] rdout2//
);
  always @(posedge clk) begin
    mem_data <= alu_result; // Read memory
    rdout2<=rdin2;//
  end
endmodule

module writeback_stage(
  input clk,
  input [31:0] mem_data,
  input [4:0] rd,
  output reg [31:0] reg_file[0:31]
);
  always @(posedge clk) begin
     reg_file[rd] <= mem_data; // Writeback
  end
endmodule
