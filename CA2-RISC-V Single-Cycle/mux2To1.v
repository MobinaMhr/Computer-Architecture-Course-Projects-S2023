`timescale 1ns/1ns

module mux2To1(in0, in1, sl, out);
        input [31:0] in0, in1;
        input sl;
        output [31:0] out;
        
        assign out = sl ? in1 : in0; 
endmodule