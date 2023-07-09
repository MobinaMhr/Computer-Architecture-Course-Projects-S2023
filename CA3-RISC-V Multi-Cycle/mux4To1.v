`timescale 1ns/1ns

module mux4To1(in0, in1, in2, in3, sl, out);
        input [31:0] in0, in1, in2, in3;
        input [1:0] sl;
        output [31:0] out;
        
        assign out =
                sl == 2'b00 ? in0 :
                sl == 2'b01 ? in1 :
                sl == 2'b10 ? in2 :
                sl == 2'b11 ? in3 :
                32'bx;
endmodule
