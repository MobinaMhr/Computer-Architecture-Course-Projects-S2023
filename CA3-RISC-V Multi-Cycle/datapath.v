module datapath(clk, rst, PCWrite, AdrSrc, MemWrite, IRWrite, ResultSrc, ALUControl, ALUSrcA, 
                ALUSrcB, ImmSrc, RegWrite, Zero, ALUResSign, funct3, funct7, op);
        input clk, rst;
        input PCWrite, AdrSrc, MemWrite, IRWrite, RegWrite;
        input [1:0] ResultSrc, ALUSrcA, ALUSrcB;
        input [2:0] ALUControl, ImmSrc;

        output Zero, ALUResSign;
        output [2:0] funct3;
        output [6:0] funct7, op;

        wire [31:0] PCOut, PCNext, Instr, SrcA, SrcB, ImmExt, ALUResult, MemReadData, Result;
        wire [31:0] memAdr, OldPC, MDROut, SrcRegA, SrcRegB, preSrcA, preSrcB, ALUOut;

        reg32B PC(.clk(clk), .rst(rst), .en(PCWrite), .dataIn(PCNext), .dataOut(PCOut));
        mux2To1 memAdrMux(.in0(PCOut), .in1(Result), .sl(AdrSrc), .out(memAdr));
        memory DataInstrMem(.clk(clk), .rst(rst), .A(memAdr), .WE(MemWrite), .WD(preSrcB), .RD(MemReadData));
        reg32B oldPCReg(.clk(clk), .rst(rst), .en(IRWrite), .dataIn(PCOut), .dataOut(OldPC));
        reg32B instrReg(.clk(clk), .rst(rst), .en(IRWrite), .dataIn(MemReadData), .dataOut(Instr));
        reg32B MDR(.clk(clk), .rst(rst), .en(1'b1), .dataIn(MemReadData), .dataOut(MDROut));
        registerFile RegFile(.clk(clk), .rst(rst), .A1(Instr[19:15]), .A2(Instr[24:20]), .A3(Instr[11:7]),
                         .WE(RegWrite), .WD(Result), .RD1(SrcRegA), .RD2(SrcRegB));
        reg32B regA(.clk(clk), .rst(rst), .en(1'b1), .dataIn(SrcRegA), .dataOut(preSrcA));
        reg32B regB(.clk(clk), .rst(rst), .en(1'b1), .dataIn(SrcRegB), .dataOut(preSrcB));
        extend immExtend(.inst(Instr[31:7]), .sl(ImmSrc), .out(ImmExt));
        mux4To1 ALUSrc1Mux(.in0(PCOut), .in1(OldPC), .in2(preSrcA), .in3(32'bx), .sl(ALUSrcA), .out(SrcA));
        mux4To1 ALUSrc2Mux(.in0(preSrcB), .in1(ImmExt), .in2(32'd4), .in3(32'bx), .sl(ALUSrcB), .out(SrcB));
        ALU mainALU(.in1(SrcA), .in2(SrcB), .sl(ALUControl), .out(ALUResult), .zero(Zero), .sign(ALUResSign));
        reg32B ALUResReg(.clk(clk), .rst(rst), .en(1'b1), .dataIn(ALUResult), .dataOut(ALUOut));
        mux4To1 resultMux(.in0(ALUOut), .in1(MDROut), .in2(ALUResult), .in3(ImmExt), .sl(ResultSrc), .out(Result));

        assign op = Instr[6:0];
        assign funct3 = Instr[14:12];
        assign funct7 = Instr[31:25];
        assign PCNext = Result;
endmodule

