`timescale 1ns/1ns

module RISCV(clk, rst);
        input clk, rst;
        wire RegWriteMHazard, RegWriteWHazard;

        wire [6:0] op, funct7;
        wire [2:0] funct3;
        wire ZeroE, ResSignE;
        wire [2:0] BranchE;
        wire [1:0] JumpE;
        
        wire [1:0] ResultSrcD, JumpD, PCSrcE;
        wire [2:0] ALUControlD, ImmSrcD, BranchD;
        wire RegWriteD, MemWriteD, ALUSrcD, LUIInstr;

        wire StallF, StallD, FlushD, FlushE;
        wire [1:0] ForwardAE, ForwardBE;
        
        wire  ResultSrcEHazard;
        wire [1:0] PCSrcEHazard; 
        wire [4:0] RdWHazard, RdMHazard, Rs1EHazard, Rs2EHazard, RdEHazard, Rs2DHazard, Rs1DHazard;
        datapath dPth(.clk(clk), .rst(rst),
                .RegWriteD(RegWriteD), .ResultSrcD(ResultSrcD), .MemWriteD(MemWriteD), .JumpD(JumpD), .BranchD(BranchD), .ALUControlD(ALUControlD),
                 .ALUSrcD(ALUSrcD), .ImmSrcD(ImmSrcD), .PCSrcE(PCSrcE), .LUIInstr(LUIInstr),
                .StallF(StallF), .StallD(StallD), .FlushD(FlushD), .FlushE(FlushE), .ForwardAE(ForwardAE), .ForwardBE(ForwardBE),
                .ZeroE(ZeroE), .ALUResSignE(ResSignE), .JumpEOut(JumpE), .BranchEOut(BranchE), .funct3(funct3), .funct7(funct7), .op(op),
                .Rs1DHazard(Rs1DHazard), .Rs2DHazard(Rs2DHazard), .RdEHazard(RdEHazard), .Rs1EHazard(Rs1EHazard), .Rs2EHazard(Rs2EHazard),
                 .PCSrcEHazard(PCSrcEHazard), .ResultSrcEHazard(ResultSrcEHazard), .RdMHazard(RdMHazard), .RegWriteMHazard(RegWriteMHazard),
                  .RdWHazard(RdWHazard), .RegWriteWHazard(RegWriteWHazard));

        controller cntrllr(.funct3(funct3), .funct7(funct7), .op(op), .JumpE(JumpE), .BranchE(BranchE), .ZeroE(ZeroE), .ResSignE(ResSignE), 
                .RegWriteD(RegWriteD), .ResultSrcD(ResultSrcD), .MemWriteD(MemWriteD), .JumpD(JumpD), .BranchD(BranchD), .ALUControlD(ALUControlD),
                 .ALUSrcD(ALUSrcD), .PCSrcE(PCSrcE), .ImmSrcD(ImmSrcD), .LUIInstr(LUIInstr));

        hazardUnit hzrdUnt(.rst(rst), .RegWriteWHazard(RegWriteWHazard), .RdWHazard(RdWHazard), .RegWriteMHazard(RegWriteMHazard), .RdMHazard(RdMHazard),
                 .ResultSrcEHazard(ResultSrcEHazard), .PCSrcEHazard(PCSrcEHazard),
                 .Rs1EHazard(Rs1EHazard), .Rs2EHazard(Rs2EHazard), .RdEHazard(RdEHazard), .Rs2DHazard(Rs2DHazard), .Rs1DHazard(Rs1DHazard),
                        .FlushE(FlushE), .FlushD(FlushD), .StallD(StallD), .StallF(StallF), .ForwardBE(ForwardBE), .ForwardAE(ForwardAE));
        always @(posedge clk) begin
                $display("-------------------------------------------------------------------------");
        end
endmodule