`timescale 1ns/1ns

module instructionMemory(A, RD);
        input [31:0] A;
        output [31:0] RD;
        wire [31:0] khoone;

        reg [31:0] memory [0:16384];
        initial begin
                $readmemb("instructions.txt", memory);
        end

        assign khoone = {2'b0, A[31:2]};
        assign RD = memory[khoone];
endmodule