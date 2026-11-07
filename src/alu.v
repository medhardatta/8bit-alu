module alu (
    input  [7:0] a,
    input  [7:0] b,
    input  [2:0] op,
    output reg [7:0] result,
    output reg carry,
    output zero
);
    reg [8:0] tmp;

    always @(*) begin
        tmp    = 9'd0;
        carry  = 1'b0;
        result = 8'd0;
        case (op)
            3'b000: begin                       // ADD
                tmp    = {1'b0, a} + {1'b0, b};
                result = tmp[7:0];
                carry  = tmp[8];
            end
            3'b001: begin                       // SUB
                tmp    = {1'b0, a} - {1'b0, b};
                result = tmp[7:0];
                carry  = tmp[8];                // borrow
            end
            3'b010: result = a & b;             // AND
            3'b011: result = a | b;             // OR
            3'b100: result = a ^ b;             // XOR
            default: result = 8'd0;
        endcase
    end

    assign zero = (result == 8'd0);
endmodule