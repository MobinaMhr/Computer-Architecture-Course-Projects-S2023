`timescale 1ns/1ns

module RISCV(clk, rst);
        input clk, rst;
        wire zero;
        wire [6:0] op, funct7;
        wire [2:0] funct3;
        wire RegWrite, ALUSrc, MemWrite, ALUResSign;
        wire [1:0] ResultSrc, PCSrc;
        wire [2:0] ALUControl, ImmSrc;
        datapath dPath(.clk(clk), .rst(rst), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .PCSrc(PCSrc), .ResultSrc(ResultSrc), .ImmSrc(ImmSrc), .ALUControl(ALUControl),
                                .Zero(zero), .ALUResSign(ALUResSign), .funct3(funct3), .funct7(funct7), .op(op));
        controller cntrller(.Zero(zero), .ALUResSign(ALUResSign), .funct3(funct3), .funct7(funct7), .op(op),
                                .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .PCSrc(PCSrc), .ResultSrc(ResultSrc), .ImmSrc(ImmSrc), .ALUControl(ALUControl));
        always @(posedge clk) begin
                $display("-------------------------------------------------------------------------");
        end
endmodule
