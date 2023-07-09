`timescale 1ns/1ns

module extend(inst, sl, out);
        input [31:7] inst;
        input [2:0] sl;
        output [31:0] out;
        
        assign out = 
                sl == 3'b000 ? {{21{inst[31]}}, inst[30:20]} : // I-Type
                sl == 3'b001 ? {{21{inst[31]}}, inst[30:25], inst[11:7]} : // S-Type
                sl == 3'b010 ? {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0} : // B-Type
                sl == 3'b100 ? {inst[31], inst[30:20], inst[19:12], 12'b0} : // U-Type
                sl == 3'b011 ?  {{12{inst[31]}}, inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0} : // J-Type
                32'bx;
endmodule