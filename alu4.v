module alu4 (
    input  [3:0] a,
    input  [3:0] b,
    input  [2:0] op,
    output reg [3:0] result,
    output reg carry,
    output zero
);

    reg [4:0] tmp;

    assign zero = (result == 4'b0000);

    always @(*) begin
        carry = 1'b0;
        tmp   = 5'b00000;
        case (op)
            3'b000: begin
                tmp    = {1'b0, a} + {1'b0, b};
                result = tmp[3:0];
                carry  = tmp[4];
            end
            3'b001: begin
                tmp    = {1'b0, a} - {1'b0, b};
                result = tmp[3:0];
                carry  = tmp[4];
            end
            3'b010: result = a & b;
            3'b011: result = a | b;
            3'b100: result = a ^ b;
            3'b101: result = ~a;
            3'b110: result = a << 1;
            3'b111: result = a >> 1;
            default: result = 4'b0000;
        endcase
    end

endmodule