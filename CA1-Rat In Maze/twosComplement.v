`timescale 1ns/1ns

module twosComplement(in, out);
        input [3:0] in;
        output [3:0] out;

        assign out = ~in + 4'b1;
endmodule