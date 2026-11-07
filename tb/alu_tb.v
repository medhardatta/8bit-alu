module tb;
    reg  [7:0] a, b;
    reg  [2:0] op;
    wire [7:0] result;
    wire carry, zero;
    integer pass, fail;

    alu dut (.a(a), .b(b), .op(op), .result(result), .carry(carry), .zero(zero));

    task check(
        input [7:0] a_in, b_in,
        input [2:0] op_in,
        input [7:0] exp_res,
        input exp_carry, exp_zero
    );
    begin
        a = a_in; b = b_in; op = op_in;
        #10;
        if (result === exp_res && carry === exp_carry && zero === exp_zero) begin
            pass = pass + 1;
            $display("PASS: a=%h b=%h op=%b -> res=%h c=%b z=%b", a, b, op, result, carry, zero);
        end else begin
            fail = fail + 1;
            $display("FAIL: a=%h b=%h op=%b -> res=%h c=%b z=%b (exp %h c=%b z=%b)",
                     a, b, op, result, carry, zero, exp_res, exp_carry, exp_zero);
        end
    end
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        pass = 0; fail = 0;

        // ADD
        check(8'd5,   8'd3,   3'b000, 8'd8,    1'b0, 1'b0);
        check(8'd255, 8'd1,   3'b000, 8'd0,    1'b1, 1'b1);
        check(8'd0,   8'd0,   3'b000, 8'd0,    1'b0, 1'b1);
        check(8'd255, 8'd255, 3'b000, 8'd254,  1'b1, 1'b0);

        // SUB
        check(8'd5,   8'd3,   3'b001, 8'd2,    1'b0, 1'b0);
        check(8'd5,   8'd5,   3'b001, 8'd0,    1'b0, 1'b1);
        check(8'd3,   8'd5,   3'b001, 8'd254,  1'b1, 1'b0);

        // AND / OR / XOR
        check(8'hF0, 8'h3C, 3'b010, 8'h30, 1'b0, 1'b0);
        check(8'hFF, 8'h00, 3'b010, 8'h00, 1'b0, 1'b1);
        check(8'hF0, 8'h0F, 3'b011, 8'hFF, 1'b0, 1'b0);
        check(8'h00, 8'h00, 3'b011, 8'h00, 1'b0, 1'b1);
        check(8'hAA, 8'hAA, 3'b100, 8'h00, 1'b0, 1'b1);
        check(8'h55, 8'hAA, 3'b100, 8'hFF, 1'b0, 1'b0);

        $display("TOTAL: %0d PASS, %0d FAIL", pass, fail);
        $finish;
    end
endmodule