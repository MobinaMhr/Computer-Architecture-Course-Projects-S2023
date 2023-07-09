`timescale 1ns/1ns

module pipeMW(clk, rst,
                RegWriteM, ResultSrcM,
                ReadDataM, RdM, ExtImmM, PCPlus4M, ALUResultM,
                RegWriteW, ResultSrcW,
                ReadDataW, RdW, ExtImmW, PCPlus4W, ALUResultW);
        
        input clk, rst;
        input RegWriteM;
        input [1:0] ResultSrcM;
        input [4:0] RdM;
        input [31:0] ReadDataM, ExtImmM, PCPlus4M, ALUResultM;
        output  RegWriteW;
        output [1:0] ResultSrcW;
        output [4:0] RdW;
        output  [31:0] ReadDataW, ExtImmW, PCPlus4W, ALUResultW;
	
        regPipe #(1) regWriteReg(clk, rst, 1'b0, 1'b1, RegWriteM, RegWriteW);
        regPipe #(2) resultSrcReg(clk, rst, 1'b0, 1'b1, ResultSrcM, ResultSrcW);

        regPipe #(5) RdReg(clk, rst, 1'b0, 1'b1, RdM, RdW);
        regPipe #(32) readDataReg(clk, rst, 1'b0, 1'b1, ReadDataM, ReadDataW);
        regPipe #(32) extImmReg(clk, rst, 1'b0, 1'b1, ExtImmM, ExtImmW);
        regPipe #(32) ALUResReg(clk, rst, 1'b0, 1'b1, ALUResultM, ALUResultW);
        regPipe #(32) pcPlus4Reg(clk, rst, 1'b0, 1'b1, PCPlus4M, PCPlus4W);
endmodule
