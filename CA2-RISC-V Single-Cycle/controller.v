`define LW 7'b0000011
`define SW 7'b0100011
`define BRANCH 7'b1100011
`define LUI 7'b0110111
`define JALR 7'b1100111
`define JAL 7'b1101111
`define ADDI 7'b0010011
`define ADD 7'b0110011
`define BEQ 3'b000
`define BNE 3'b001
`define BLT 3'b100
`define BGE 3'b101
`define I_TYPE 3'b000
`define S_TYPE 3'b001
`define B_TYPE 3'b010
`define U_TYPE 3'b100
`define J_TYPE 3'b011
`define ADD_FUN3 3'b000
`define ADD_FUN7 7'b0000000
`define ADDI_FUN3 3'b000
`define SUB_FUN3 3'b000
`define SUB_FUN7 7'b0100000
`define XOR_FUN3 3'b100
`define AND_FUN3 3'b111
`define OR_FUN3 3'b110 // or ORI_FUN3
`define SLT_FUN3 3'b010 // or SLTI_FUN3
`define ALU_SUB 3'b001
`define ALU_ADD 3'b000
`define ALU_XOR 3'b100
`define ALU_AND 3'b010
`define ALU_OR 3'b011
`define ALU_SLT 3'b101
`define PC_PLUS_4 2'b00
`define PC_PLUS_IMM 2'b01
`define PC_PLUS_JADR 2'b10

module controller(Zero, ALUResSign, funct3, funct7, op,
                        MemWrite, ALUSrc, RegWrite, PCSrc, ResultSrc, ImmSrc, ALUControl);
        input Zero, ALUResSign;
        input [2:0] funct3;
        input [6:0] funct7, op;

        output reg MemWrite, ALUSrc, RegWrite;
        output reg [1:0] PCSrc, ResultSrc;
        output reg [2:0] ALUControl, ImmSrc;
        reg [1:0] ALUOp;

        always @(op, funct3, funct7) begin
                {PCSrc, ResultSrc, MemWrite, ALUControl, ALUSrc, ImmSrc, RegWrite, ALUOp} = 15'b0;
                case (op)
                        `LW: begin
                                ALUSrc = 1'b1;
                                ImmSrc = `I_TYPE;
                                ALUOp = 2'b00;
                                ResultSrc = 2'b01;
                                RegWrite = 1'b1;
                        end

                        `ADDI: begin
                                ALUSrc = 1'b1;
                                ImmSrc = `I_TYPE;
                                ALUOp = 2'b10;
                                ResultSrc = 2'b00;
                                RegWrite = 1'b1;
                        end

                        `SW: begin
                                ALUSrc = 1'b1;
                                ImmSrc = `S_TYPE;
                                ALUOp = 2'b00;
                                MemWrite = 1'b1;
                        end
                        
                        `BRANCH: begin
                                ALUSrc = 1'b1;
                                ImmSrc = `B_TYPE;
                                ALUOp = 2'b01;
                                if (funct3 == `BEQ)
                                        PCSrc = Zero ? `PC_PLUS_IMM : `PC_PLUS_4;
                                
                                else if (funct3 == `BNE)
                                        PCSrc = ~Zero ? `PC_PLUS_IMM : `PC_PLUS_4;

                                else if (funct3 == `BLT)
                                        PCSrc = ALUResSign ? `PC_PLUS_IMM : `PC_PLUS_4;

                                else if (funct3 == `BGE)
                                        PCSrc = ~ALUResSign ? `PC_PLUS_IMM : `PC_PLUS_4;
                        end

                        `ADD: begin
                                RegWrite = 1'b1;
                                ALUOp = 2'b10;
                        end

                        `LUI: begin
                                RegWrite = 1'b1;
                                ResultSrc = 2'b11;
                                ImmSrc = `U_TYPE;
                        end

                        `JALR: begin
                                ALUSrc = 1'b1;
                                RegWrite = 1'b1;
                                PCSrc = 2'b10;
                                ResultSrc = 2'b10;
                                ImmSrc = `I_TYPE;
                                ALUOp = 2'b00;
                        end

                        `JAL: begin
                                ALUSrc = 1'b1;
                                RegWrite = 1'b1;
                                PCSrc = 2'b01;
                                ResultSrc = 2'b10;
                                ImmSrc = `J_TYPE;
                                ALUOp = 2'b00;
                        end

                        default: begin
                                {PCSrc, ResultSrc, MemWrite, ALUControl, ALUSrc, ImmSrc, RegWrite, ALUOp} = 15'b0;
                        end
                endcase
        end

        always @(ALUOp) begin
                case (ALUOp) 
                        2'b00:
                                ALUControl = `ALU_ADD;
                        2'b01:
                                ALUControl = `ALU_SUB;
                        2'b10: begin
                                if (funct3 == `ADDI_FUN3 && op == `ADDI)
                                        ALUControl = `ALU_ADD;

                                if (funct3 == `ADD_FUN3 && funct7 == `ADD_FUN7)
                                        ALUControl = `ALU_ADD;
                                
                                if (funct3 == `SUB_FUN3 && funct7 == `SUB_FUN7)
                                        ALUControl = `ALU_SUB;
                                
                                if (funct3 == `XOR_FUN3)
                                        ALUControl = `ALU_XOR;
                                
                                if (funct3 == `AND_FUN3)
                                        ALUControl = `ALU_AND;
                                
                                if (funct3 == `OR_FUN3)
                                        ALUControl = `ALU_OR;
                                
                                if (funct3 == `SLT_FUN3)
                                        ALUControl = `ALU_SLT;
                        end
                endcase
        end 
endmodule
