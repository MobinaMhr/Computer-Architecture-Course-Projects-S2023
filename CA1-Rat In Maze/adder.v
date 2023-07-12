module adder(a, b, ci, en, co, sum);
        #parameter N = 4;
        input [N - 1:0] a, b;
        input ci, en;
        output co;
        output [N - 1:0] sum;
        assign {co, sum} = en ? a + b + ci: {co, sum};
endmodule