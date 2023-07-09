`timescale 1ns/1ns

module memory(clk, rst, A, WE, WD, RD);
        input clk, rst;
        input [31:0] A;
        input WE;
        input [31:0] WD;
        output [31:0] RD;
        wire [31:0] khoone;
        integer i;

        reg [31:0] memory [0:16384];

        initial begin
                $readmemh("data.txt", memory);
        end

        assign khoone = {2'b0, A[31:2]};

        always @(posedge clk, posedge rst) begin
                if (WE) begin
                        memory[khoone] <= WD;
                end
        end
        
        assign RD = memory[khoone];
endmodule