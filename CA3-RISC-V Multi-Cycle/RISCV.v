`timescale 1ns/1ns

module RISCV(clk, rst);
        input clk, rst;
        wire PCWrite, AdrSrc, MemWrite, IRWrite, RegWrite;
        wire [1:0] ResultSrc, ALUSrcA, ALUSrcB;
        wire [2:0] ALUControl, ImmSrc;

        wire Zero, ALUResSign;
        wire [2:0] funct3;
        wire [6:0] funct7, op;
        
         datapath dPath(clk, rst, PCWrite, AdrSrc, MemWrite, IRWrite, ResultSrc, ALUControl, ALUSrcA, ALUSrcB, ImmSrc, RegWrite,
                        Zero, ALUResSign, funct3, funct7, op);

        controller cntrller(clk, rst, Zero, ALUResSign, op, funct7, funct3,
                        PCWrite, AdrSrc, MemWrite, IRWrite, ImmSrc, RegWrite, ALUControl, ALUSrcA, ALUSrcB, ResultSrc);
                        
        always @(posedge clk) begin
                $display("-------------------------------------------------------------------------");
        end
endmodule
