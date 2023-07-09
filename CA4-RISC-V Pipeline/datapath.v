`timescale 1ns/1ns

module datapath(clk, rst,
                RegWriteD, ResultSrcD, MemWriteD, JumpD, BranchD, ALUControlD, ALUSrcD, ImmSrcD, PCSrcE, LUIInstr, // inputs from controller
                StallF, StallD, FlushD, FlushE, ForwardAE, ForwardBE, // inputs from hazard unit
                ZeroE, ALUResSignE, JumpEOut/*1bit?*/, BranchEOut/*1bit?*/, funct3, funct7, op, // outputs to controller
                Rs1DHazard, Rs2DHazard, RdEHazard, Rs1EHazard, Rs2EHazard, PCSrcEHazard, ResultSrcEHazard/*1bit?*/, RdMHazard, 
                        RegWriteMHazard, RdWHazard, RegWriteWHazard); // outputs to hazard unit
        input clk, rst;
        input RegWriteD, MemWriteD, ALUSrcD, LUIInstr, StallF, StallD, FlushD, FlushE;
        input [1:0] ResultSrcD, JumpD, PCSrcE, ForwardAE, ForwardBE;
        input [2:0] ALUControlD, ImmSrcD, BranchD;
        output  ResultSrcEHazard/*1bit?*/, 
                        RegWriteMHazard, RegWriteWHazard;
        output [4:0] RdWHazard, RdMHazard, Rs1EHazard, Rs2EHazard, RdEHazard, Rs2DHazard, Rs1DHazard;
        output ZeroE, ALUResSignE;
        output [1:0] PCSrcEHazard, JumpEOut;
        output [2:0] funct3, BranchEOut;
        output [6:0] funct7, op;
        // output [4:0] Rs1EHazard, Rs2EHazard;
        wire [31:0] PCPlus4F, PCF, secPCF, InstrF;
        wire [31:0] InstrD, RD1D, RD2D, PCD, ExtImmD, PCPlus4D;
        
        wire RegWriteE, MemWriteE, ALUSrcE;
        wire [1:0] ResultSrcE, JumpE;
        wire [2:0] ALUControlE, BranchE;
        wire [4:0] Rs1E, Rs2E, RdE;
        wire [31:0] RD1E, RD2E, PCE, ExtImmE, PCPlus4E, SrcAE, SrcBE, ALUResultE, WriteDataE, PCTargetE;

        wire RegWriteM, MemWriteM;
        wire [1:0] ResultSrcM;
        wire [4:0] RdM;
        wire [31:0] ALUResultM, WriteDataM, ExtImmM, PCPlus4M, ReadDataM, memToExBackward;

        wire RegWriteW;
        wire [1:0] ResultSrcW;
        wire [4:0] RdW;
        wire [31:0] PCPlus4W, ReadDataW, ExtImmW, ResultW, ALUResultW;
        wire LUIInstrE, LUIInstrM;
        wire co1, co2;

        mux4To1 PCFMux(.in0(PCPlus4F), .in1(PCTargetE), .in2(ALUResultE), .in3(32'bx), .sl(PCSrcE), .out(secPCF));
        reg32B PC(.clk(clk), .rst(rst), .en(~StallF), .dataIn(secPCF), .dataOut(PCF));
        instructionMemory InstructionMem(.A(PCF), .RD(InstrF));
        adder32B PCIncrementBy4(.in1(PCF), .in2(32'd4), .sum(PCPlus4F), .c(co1));
        pipeFD pipe1(clk, rst, ~StallD, FlushD, InstrF, PCF, PCPlus4F, InstrD, PCD, PCPlus4D);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        registerFile RegFile(.clk(clk), .rst(rst), .A1(InstrD[19:15]), .A2(InstrD[24:20]), .A3(RdW),
                         .WE(RegWriteW), .WD(ResultW), .RD1(RD1D), .RD2(RD2D));
        extend immExtend(.inst(InstrD[31:7]), .sl(ImmSrcD), .out(ExtImmD));
        pipeDE pipe2(clk, rst, FlushE, 
                RegWriteD, ResultSrcD, MemWriteD, JumpD, BranchD, ALUControlD, ALUSrcD, LUIInstr,
                RD1D, RD2D, PCD, InstrD[19:15], InstrD[24:20], InstrD[11:7], ExtImmD, PCPlus4D,
                RegWriteE, ResultSrcE, MemWriteE, JumpE, BranchE, ALUControlE, ALUSrcE, LUIInstrE,
                RD1E, RD2E, PCE, Rs1E, Rs2E, RdE, ExtImmE, PCPlus4E);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        mux4To1 srcAMux(.in0(RD1E), .in1(ResultW), .in2(memToExBackward), .in3(32'bx), .sl(ForwardAE), .out(SrcAE));
        mux4To1 srcBMux(.in0(RD2E), .in1(ResultW), .in2(memToExBackward), .in3(32'bx), .sl(ForwardBE), .out(WriteDataE));
        mux2To1 srcBMux2(.in0(WriteDataE), .in1(ExtImmE), .sl(ALUSrcE), .out(SrcBE));
        adder32B addderE(.in1(PCE), .in2(ExtImmE), .sum(PCTargetE), .c(co2));
        ALU mainALU(.in1(SrcAE), .in2(SrcBE), .sl(ALUControlE), .out(ALUResultE), .zero(ZeroE), .sign(ALUResSignE));
        pipeEM pipe3(clk, rst,
                RegWriteE, ResultSrcE, MemWriteE, LUIInstrE,
                ALUResultE, WriteDataE, RdE, ExtImmE, PCPlus4E,
                RegWriteM, ResultSrcM, MemWriteM, LUIInstrM,
                ALUResultM, WriteDataM, RdM, ExtImmM, PCPlus4M);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        dataMemory DataMem(.clk(clk), .rst(rst), .A(ALUResultM), .WE(MemWriteM), .WD(WriteDataM), .RD(ReadDataM));
        mux2To1 memToExMux(.in0(ALUResultM), .in1(ExtImmM), .sl(LUIInstrM), .out(memToExBackward));
        pipeMW pipe4(clk, rst,
                RegWriteM, ResultSrcM,
                ReadDataM, RdM, ExtImmM, PCPlus4M, ALUResultM,
                RegWriteW, ResultSrcW,
                ReadDataW, RdW, ExtImmW, PCPlus4W, ALUResultW);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        mux4To1 resMux(.in0(ALUResultW), .in1(ReadDataW), .in2(PCPlus4W), .in3(ExtImmW), .sl(ResultSrcW), .out(ResultW));

        assign op = InstrD[6:0];
        assign funct3 = InstrD[14:12];
        assign funct7 = InstrD[31:25];
        assign JumpEOut = JumpE;
        assign BranchEOut = BranchE;

        assign Rs1DHazard = InstrD[19:15];
        assign Rs2DHazard = InstrD[24:20];
        assign Rs1EHazard = Rs1E;
        assign Rs2EHazard = Rs2E;
        assign RdEHazard = RdE;
        assign PCSrcEHazard = PCSrcE;
        assign ResultSrcEHazard = ResultSrcE[0]; // sure?
        assign RdMHazard = RdM;
        assign RegWriteMHazard = RegWriteM;
        assign RdWHazard = RdW;
        assign RegWriteWHazard = RegWriteW;

        

endmodule

