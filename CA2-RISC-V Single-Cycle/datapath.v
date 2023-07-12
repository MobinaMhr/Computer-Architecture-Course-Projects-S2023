module datapath(clk, rst, MemWrite, ALUSrc, RegWrite, PCSrc, ResultSrc, ImmSrc, ALUControl,
                        Zero, ALUResSign, funct3, funct7, op);
        input clk, rst;
        input  MemWrite, ALUSrc, RegWrite;
        input [1:0] PCSrc, ResultSrc;
        input [2:0] ALUControl, ImmSrc;

        output Zero, ALUResSign;
        output [2:0] funct3;
        output [6:0] funct7, op;

        wire [31:0] PCOut, PCNext, PCPlus4, Instr, SrcA, preSrcB, SrcB, ImmExt, 
                    ALUResult, PCTarget, MemReadData, RFWriteData;
        wire co1, co2;

        mux4To1 PCInMux(.in0(PCPlus4), .in1(PCTarget), .in2(ALUResult), .in3(32'bx), .sl(PCSrc), .out(PCNext));
        reg32B PC(.clk(clk), .rst(rst), .dataIn(PCNext), .dataOut(PCOut));
        instructionMemory InstructionMem(.A(PCOut), .RD(Instr));
        adder32B PCIncrementBy4(.in1(PCOut), .in2(32'd4), .sum(PCPlus4), .c(co1));
        registerFile RegFile(.clk(clk), .rst(rst), .A1(Instr[19:15]), .A2(Instr[24:20]), .A3(Instr[11:7]),
                         .WE(RegWrite), .WD(RFWriteData), .RD1(SrcA), .RD2(preSrcB));
        extend immExtend(.inst(Instr[31:7]), .sl(ImmSrc), .out(ImmExt));
        mux2To1 ALUSrc2Mux(.in0(preSrcB), .in1(ImmExt), .sl(ALUSrc), .out(SrcB));
        ALU mainALU(.in1(SrcA), .in2(SrcB), .sl(ALUControl), .out(ALUResult), .zero(Zero), .sign(ALUResSign));
        adder32B PCAdd(.in1(PCOut), .in2(ImmExt), .sum(PCTarget), .c(co2));
        dataMemory DataMem(.clk(clk), .rst(rst), .A(ALUResult), .WE(MemWrite), .WD(preSrcB), .RD(MemReadData));
        mux4To1 RegFileWDMux(.in0(ALUResult), .in1(MemReadData), .in2(PCPlus4), .in3(ImmExt), .sl(ResultSrc), .out(RFWriteData));

        assign op = Instr[6:0];
        assign funct3 = Instr[14:12];
        assign funct7 = Instr[31:25];

endmodule

