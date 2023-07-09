`timescale 1ns/1ns

module pipeDE(clk, rst, clr, 
                RegWriteD, ResultSrcD, MemWriteD, JumpD, BranchD, ALUControlD, ALUSrcD, LUIInstrD,
                RD1D, RD2D, PCD, Rs1D, Rs2D, RdD, ExtImmD, PCPlus4D,
                RegWriteE, ResultSrcE, MemWriteE, JumpE, BranchE, ALUControlE, ALUSrcE, LUIInstrE,
                RD1E, RD2E, PCE, Rs1E, Rs2E, RdE, ExtImmE, PCPlus4E);
        
        input clk, rst, clr;
        input RegWriteD, MemWriteD, ALUSrcD, LUIInstrD;
        input [1:0] ResultSrcD, JumpD;
        input [2:0] ALUControlD, BranchD;
        input [4:0] Rs1D, Rs2D, RdD;
        input [31:0] RD1D, RD2D, PCD, ExtImmD, PCPlus4D;
        output   RegWriteE, MemWriteE, ALUSrcE, LUIInstrE;
        output   [1:0] ResultSrcE, JumpE;
        output   [2:0] ALUControlE, BranchE;
        output   [4:0] Rs1E, Rs2E, RdE;
        output   [31:0] RD1E, RD2E, PCE, ExtImmE, PCPlus4E;

        regPipe #(1) regWriteReg(clk, rst, clr, 1'b1, RegWriteD, RegWriteE);
        regPipe #(1) memWriteReg(clk, rst, clr, 1'b1, memWriteD, memWriteE);
        regPipe #(1) ALUSrcReg(clk, rst, clr, 1'b1, ALUSrcD, ALUSrcE);
        regPipe #(1) luiReg(clk, rst, clr, 1'b1, LUIInstrD, LUIInstrE);
        regPipe #(2) jumpReg(clk, rst, clr, 1'b1, JumpD, JumpE);
        regPipe #(2) resultSrcReg(clk, rst, clr, 1'b1, ResultSrcD, ResultSrcE);
        regPipe #(3) branchReg(clk, rst, clr, 1'b1, BranchD, BranchE);
        regPipe #(3) ALUControlReg(clk, rst, clr, 1'b1, ALUControlD, ALUControlE);

        regPipe #(5) Rs1Reg(clk, rst, clr, 1'b1, Rs1D, Rs1E);
        regPipe #(5) Rs2Reg(clk, rst, clr, 1'b1, Rs2D, Rs2E);
        regPipe #(5) Rd3Reg(clk, rst, clr, 1'b1, RdD, RdE);
        regPipe #(32) RD1Reg(clk, rst, clr, 1'b1, RD1D, RD1E);
        regPipe #(32) RD2Reg(clk, rst, clr, 1'b1, RD2D, RD2E);
        regPipe #(32) PCReg(clk, rst, clr, 1'b1, PCD, PCE);
        regPipe #(32) extImmReg(clk, rst, clr, 1'b1, ExtImmD, ExtImmE);
        regPipe #(32) pcPlus4Reg(clk, rst, clr, 1'b1, PCPlus4D, PCPlus4E);
endmodule
