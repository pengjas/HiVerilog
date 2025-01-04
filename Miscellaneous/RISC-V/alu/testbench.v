`timescale 1ns / 1ps

module test_modular_alu();

    reg [31:0] a;
    reg [31:0] b;
    reg [5:0] aluc;
    wire [31:0] r;
    wire zero;
    wire carry;
    wire negative;
    wire overflow;
    wire flag;
    reg [4:0] cnt;

    modular_alu uut(a, b, aluc, r, zero, carry, negative, overflow, flag);

    parameter ADD = 6'b100000;
    parameter ADDU = 6'b100001;
    parameter SUB = 6'b100010;
    parameter SUBU = 6'b100011;
    parameter AND = 6'b100100;
    parameter OR = 6'b100101;
    parameter XOR = 6'b100110;
    parameter NOR = 6'b100111;
    parameter SLT = 6'b101010;
    parameter SLTU = 6'b101011;
    parameter SLL = 6'b000000;
    parameter SRL = 6'b000010;
    parameter SRA = 6'b000011;
    parameter SLLV = 6'b000100;
    parameter SRLV = 6'b000110;
    parameter SRAV = 6'b000111;
    parameter LUI = 6'b001111;

    reg [5:0] opcodes[0:16];
    reg [31:0] reference[0:16];
    reg error = 0;
    integer file_open;

    initial begin
        // Load reference results from a file
        $readmemh("reference.dat", reference);

        // Initialize opcodes for each operation
        opcodes[0] = ADD;
        opcodes[1] = ADDU;
        opcodes[2] = SUB;
        opcodes[3] = SUBU;
        opcodes[4] = AND;
        opcodes[5] = OR;
        opcodes[6] = XOR;
        opcodes[7] = NOR;
        opcodes[8] = SLT;
        opcodes[9] = SLTU;
        opcodes[10] = SLL;
        opcodes[11] = SRL;
        opcodes[12] = SRA;
        opcodes[13] = SLLV;
        opcodes[14] = SRLV;
        opcodes[15] = SRAV;
        opcodes[16] = LUI;

        // Test values for a and b
        a = 32'h0000001c;
        b = 32'h00000021;
        #5;

        cnt = 0;

        // Loop through each operation and test
        for (cnt = 0; cnt < 17; cnt = cnt + 1) begin
            #5;
            aluc = opcodes[cnt];
            #5;
            error = error | (reference[cnt] != r);
        end

        // Check for errors and display results
        if (error == 0) begin
            $display("===========Your Design Passed===========");
        end else begin
            $display("===========Error===========");
        end
        
        // End the simulation
        $finish;
    end
endmodule