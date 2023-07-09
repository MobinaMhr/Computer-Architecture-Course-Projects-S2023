`timescale 1ns/1ns

module pipeEM(clk, rst,
                RegWriteE, ResultSrcE, MemWriteE, LUIInstrE,
                ALUResultE, WriteDataE, RdE, ExtImmE, PCPlus4E,
                RegWriteM, ResultSrcM, MemWriteM, LUIInstrM,
                ALUResultM, WriteDataM, RdM, ExtImmM, PCPlus4M);
        
        input clk, rst;
        input RegWriteE, MemWriteE, LUIInstrE;
        input [1:0] ResultSrcE;
        input [4:0] RdE;
        input [31:0] ALUResultE, WriteDataE, ExtImmE, PCPlus4E;
        output  RegWriteM, MemWriteM, LUIInstrM;
        output  [1:0] ResultSrcM;
        output   [4:0] RdM;
        output   [31:0] ALUResultM, WriteDataM, ExtImmM, PCPlus4M;
	
        regPipe #(1) regWriteReg(clk, rst, 1'b0, 1'b1, RegWriteE, RegWriteM);
        regPipe #(1) memWriteReg(clk, rst, 1'b0, 1'b1, memWriteE, memWriteM);
        regPipe #(1) luiReg(clk, rst, 1'b0, 1'b1, LUIInstrE, LUIInstrM);
        regPipe #(2) resultSrcReg(clk, rst, 1'b0, 1'b1, ResultSrcE, ResultSrcM);

        regPipe #(5) RdReg(clk, rst, 1'b0, 1'b1, RdE, RdM);
        regPipe #(32) ALUResultReg(clk, rst, 1'b0, 1'b1, ALUResultE, ALUResultM);
        regPipe #(32) writeDataReg(clk, rst, 1'b0, 1'b1, WriteDataE, WriteDataM);
        regPipe #(32) extImmReg(clk, rst, 1'b0, 1'b1, ExtImmE, ExtImmM);
        regPipe #(32) pcPlus4Reg(clk, rst, 1'b0, 1'b1, PCPlus4E, PCPlus4M);
endmodule
