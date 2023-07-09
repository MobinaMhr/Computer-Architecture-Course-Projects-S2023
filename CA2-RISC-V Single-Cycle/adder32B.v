`timescale 1ns/1ns

module adder32B(in1, in2, sum, c);
        input [31:0] in1, in2;
        output [31:0] sum;
        output c;     
        assign {c, sum} = in1 + in2;
endmodule