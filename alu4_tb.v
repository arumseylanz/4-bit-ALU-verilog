`timescale 1ns/1ps

module alu4_tb;

    reg  [3:0] a, b;
    reg  [2:0] op;
    wire [3:0] result;
    wire       carry, zero;

    integer i, j, k;
    integer errors, tests;
    reg [3:0] exp_result;
    reg       exp_carry;

    alu4 dut (.a(a), .b(b), .op(op),
              .result(result), .carry(carry), .zero(zero));

    initial begin
        errors = 0;
        tests  = 0;

        for (k = 0; k < 8; k = k + 1) begin
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    op = k;
                    a  = i;
                    b  = j;
                    #1;

                    exp_carry = 1'b0;
                    case (k)
                        0: begin exp_result = (i + j) % 16;
                                 exp_carry  = ((i + j) >= 16); end
                        1: begin exp_result = (i - j + 16) % 16;
                                 exp_carry  = (i < j); end
                        2: exp_result = i & j;
                        3: exp_result = i | j;
                        4: exp_result = i ^ j;
                        5: exp_result = (~i) & 15;
                        6: exp_result = (i * 2) % 16;
                        7: exp_result = i / 2;
                    endcase

                    tests = tests + 1;
                    if (result !== exp_result ||
                        carry  !== exp_carry  ||
                        zero   !== (exp_result == 0)) begin
                        errors = errors + 1;
                        $display("FAIL op=%0d a=%0d b=%0d -> result=%0d carry=%b zero=%b (expected %0d, %b)",
                                 k, i, j, result, carry, zero, exp_result, exp_carry);
                    end
                end
            end
        end

        if (errors == 0)
            $display("PASS: all %0d tests passed", tests);
        else
            $display("FAILED: %0d errors out of %0d tests", errors, tests);

        $finish;
    end

endmodule