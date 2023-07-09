`timescale 1ns/1ns

module adder(a, b, ci, en, co, sum);
        input [3:0] a, b;
        input ci, en;
        output co;
        output [3:0] sum;
        assign {co, sum} = en? a + b + ci: {co, sum};
endmodule