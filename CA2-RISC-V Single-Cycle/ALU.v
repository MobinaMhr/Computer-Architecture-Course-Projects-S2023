`timescale 1ns/1ns
`define ALU_SUB 3'b001
`define ALU_ADD 3'b000
`define ALU_XOR 3'b100
`define ALU_AND 3'b010
`define ALU_OR 3'b011
`define ALU_SLT 3'b101

module ALU(in1, in2, sl, out, zero, sign);
        input [31:0] in1, in2;
        input [2:0] sl;
        output zero, sign;
        output reg [31:0] out;

        always @(in1, in2, sl) begin
                out = 32'b0;
                case (sl)
                        `ALU_ADD:
                                out = in1 + in2;
                        `ALU_SUB:
                                out = in1 - in2;
                        `ALU_AND:
                                out = in1 & in2;
                        `ALU_OR:
                                out = in1 | in2;
                        `ALU_XOR:
                                out = in1 ^ in2;
                        `ALU_SLT:
                                out = (in1 < in2 ? 32'd1 : 32'd0);
                        default: out = 32'b0;
                endcase
        end

        assign zero = (out == 32'b0);
        assign sign = (out[31]);
endmodule