`timescale 1ns/1ns
`define LW_OP 7'b0000011
`define SW_OP 7'b0100011
`define BRANCH_OP 7'b1100011
`define LUI_OP 7'b0110111
`define JALR_OP 7'b1100111
`define JAL_OP 7'b1101111
`define ADDI_OP 7'b0010011
`define ADD_OP 7'b0110011

`define I_TYPE_ImmSrc 3'b000
`define S_TYPE_ImmSrc 3'b001
`define B_TYPE_ImmSrc 3'b010
`define U_TYPE_ImmSrc 3'b100
`define J_TYPE_ImmSrc 3'b011
`define ADDI 7'b0010011
`define ADD_FUN3 3'b000
`define SUB_FUN3 3'b000
`define AND_FUN3 3'b111
`define OR_FUN3 3'b110
`define SLT_FUN3 3'b010
`define XOR_FUN3 3'b100
`define ADDI_FUN3 3'b000
`define XORI_FUN3 3'b100
`define ORI_FUN3 3'b110
`define SLTI_FUN3 3'b010
`define JALR_FUN3 3'b000
`define LW_FUN3 3'b010


`define ADD_FUN7 7'b0000000
`define SUB_FUN7 7'b01000000
`define AND_FUN7 7'b0000000
`define OR_FUN7 7'b0000000
`define SLT_FUN7 7'b0000000

`define ALU_SUB 3'b001
`define ALU_ADD 3'b000
`define ALU_XOR 3'b100
`define ALU_AND 3'b010
`define ALU_OR 3'b011
`define ALU_SLT 3'b101

`define branchEq 3'b001
`define branchNEq 3'b010
`define branchLEq 3'b011
`define branchGEq 3'b100
`define notBranch 3'b000
`define jumpRegister 2'b10
`define jump 2'b11

`define BEQ 3'b000
`define BNE 3'b001
`define BLT 3'b100
`define BGE 3'b101

`define PC_PLUS_4 2'b00
`define PC_PLUS_IMM 2'b01
`define PC_PLUS_JADR 2'b10

module controller(funct3, funct7, op, JumpE, BranchE, ZeroE, ResSignE, 
                RegWriteD, ResultSrcD, MemWriteD, JumpD, BranchD, ALUControlD, ALUSrcD, PCSrcE, ImmSrcD, LUIInstr);
        input [2:0] funct3;
        input [6:0] funct7, op;
        input ZeroE, ResSignE;
        input [1:0] JumpE;
        input [2:0] BranchE;
        output reg [1:0] ResultSrcD, PCSrcE, JumpD;
        output reg [2:0] ALUControlD, ImmSrcD, BranchD;
        output reg RegWriteD, MemWriteD, ALUSrcD, LUIInstr;
        reg [1:0] ALUOp;
//  always@(op,funct3,funct7) begin
//         case(op)
//             7'b0110011: begin                                     //R
//                             LUIInstr = 1'b0;
//                             JumpD = 2'b00;
//                             BranchD = 3'b000;
//                             ResultSrcD = 2'b00;
//                             MemWriteD = 1'b0;
//                             ALUSrcD = 1'b0;
//                             RegWriteD = 1'b1;
//                             if(funct7 == 7'b0000000 && funct3 == 3'b000) ALUControlD = 3'b000;
//                             else if(funct7 == 7'b0100000 && funct3 == 3'b000) ALUControlD = 3'b001;
//                             else if(funct7 == 7'b0000000 && funct3 == 3'b111) ALUControlD = 3'b010;
//                             else if(funct7 == 7'b0000000 && funct3 == 3'b110) ALUControlD = 3'b011;
//                             else if(funct7 == 7'b0000000 && funct3 == 3'b010) ALUControlD = 3'b100;

//                         end

//             7'b0000011: begin                                   //lw
//                             LUIInstr = 1'b0;
//                             JumpD = 2'b00;
//                             BranchD = 3'b000;
//                             ResultSrcD = 2'b01;
//                             MemWriteD = 1'b0;
//                             ALUControlD = 3'b000;
//                             ALUSrcD = 1'b1;
//                             ImmSrcD = 3'b000;
//                             RegWriteD = 1'b1;
//                         end

//             7'b0010011: begin                                   //I
//                             LUIInstr = 1'b0;
//                             JumpD = 2'b00;
//                             BranchD = 3'b000;
//                             ResultSrcD = 2'b00;
//                             MemWriteD = 1'b0;
//                             ALUSrcD = 1'b1;
//                             ImmSrcD = 3'b000;
//                             RegWriteD = 1'b1;
//                             if(funct3 == 3'b000) ALUControlD = 3'b000;
//                             else if(funct3 == 3'b100) ALUControlD = 3'b101;
//                             else if(funct3 == 3'b110) ALUControlD = 3'b011;
//                             else if(funct3 == 3'b010) ALUControlD = 3'b100;
//                         end

//             7'b1100111: begin                                   //jalr
//                             LUIInstr = 1'b0;
//                             JumpD = 2'b01;
//                             BranchD = 3'b000;
//                             ResultSrcD = 2'b10;
//                             MemWriteD = 1'b0;
//                             ALUControlD = 3'b000;
//                             ALUSrcD = 1'b1;
//                             ImmSrcD = 3'b000;
//                             RegWriteD = 1'b1;
//                         end

//             7'b0100011: begin                                   //S
//                             LUIInstr = 1'b0;
//                             JumpD = 2'b00;
//                             BranchD = 3'b000;
//                             MemWriteD = 1'b1;
//                             ALUControlD = 3'b000;
//                             ALUSrcD = 1'b1;
//                             ImmSrcD = 3'b001;
//                             RegWriteD = 1'b0;
//                         end

//             7'b1101111: begin                                   //jal
//                             LUIInstr = 1'b0;
//                             JumpD = 2'b10;
//                             BranchD = 3'b000;
//                             ResultSrcD = 2'b10;
//                             MemWriteD = 1'b0;
//                             ImmSrcD = 3'b100;
//                             RegWriteD = 1'b1;
//                         end

//             7'b1100011: begin                                   //B
//                             LUIInstr = 1'b0;
//                             JumpD = 2'b00;
//                             MemWriteD = 1'b0;
//                             ALUControlD = 3'b001;
//                             ALUSrcD = 1'b0;
//                             ImmSrcD = 3'b010;
//                             RegWriteD = 1'b0;
//                             if (funct3 == 3'b000)  BranchD = 3'b001;
//                             else if (funct3 == 3'b001)  BranchD = 3'b010; 
//                             else if (funct3 == 3'b100)  BranchD = 3'b011; 
//                             else if (funct3 == 3'b101)  BranchD = 3'b100; 
// 			                else BranchD = 3'b000;
//                         end

//             7'b0110111: begin
//                             LUIInstr = 1'b1;
//                             JumpD = 2'b00;
//                             BranchD = 3'b000;
//                             ResultSrcD = 2'b11;
//                             MemWriteD = 1'b0;
//                             ImmSrcD = 3'b011;
//                             RegWriteD = 1'b1;
//                         end
// 		    default: begin
//                             JumpD = 2'b00;
//                             BranchD = 3'b000;
//                         end
//         endcase 
//     end
        always @(op, funct3, funct7) begin
                {ResultSrcD, MemWriteD, ALUControlD, ALUSrcD, ImmSrcD, RegWriteD, ALUOp, LUIInstr, JumpD, BranchD} = 21'b0;
                case (op)
                        `LW_OP: begin
                                ALUSrcD = 1'b1;
                                ImmSrcD = `I_TYPE_ImmSrc;
                                ALUOp = 2'b00;
                                ResultSrcD = 2'b01;
                                RegWriteD = 1'b1;
                                LUIInstr = 1'b1;

                        end

                        `ADDI_OP: begin
                                ALUSrcD = 1'b1;
                                ImmSrcD = `I_TYPE_ImmSrc;
                                ALUOp = 2'b10;
                                ResultSrcD = 2'b00;
                                RegWriteD = 1'b1;
                                ALUOp = 2'b10;
                        end

                        `SW_OP: begin
                                ALUSrcD = 1'b1;
                                ImmSrcD = `S_TYPE_ImmSrc;
                                ALUOp = 2'b00;
                                MemWriteD = 1'b1;
                        end

                        `BRANCH_OP: begin
                                BranchD = (funct3 == `BEQ) ? `branchEq :
                                                (funct3 == `BNE) ? `branchNEq :
                                                (funct3 == `BLT) ? `branchLEq :
                                                (funct3 == `BGE) ? `branchGEq :
                                                3'b101;//this one will never happen
                                ALUSrcD = 1'b0;
                                ImmSrcD = `B_TYPE_ImmSrc;
                                ALUOp = 2'b01;
                        end

                        `ADD_OP: begin
                                RegWriteD = 1'b1;
                                ALUOp = 2'b10;
                        end

                        `LUI_OP: begin
                                RegWriteD = 1'b1;
                                ResultSrcD = 2'b11;
                                ImmSrcD = `U_TYPE_ImmSrc;
                                LUIInstr = 1'b1;
                        end

                        `JALR_OP: begin
                                BranchD = `notBranch;
                                JumpD = `jumpRegister;
                                ALUSrcD = 1'b1;
                                RegWriteD = 1'b1;
                                // PCSrc = 2'b10;
                                ResultSrcD = 2'b10;
                                ImmSrcD = `I_TYPE_ImmSrc;
                                ALUOp = 2'b00;
                        end

                        `JAL_OP: begin
                                BranchD = `notBranch;
                                JumpD = `jump;
                                ALUSrcD = 1'b1;
                                RegWriteD = 1'b1;
                                ResultSrcD = 2'b10;
                                ImmSrcD = `J_TYPE_ImmSrc;
                                ALUOp = 2'b00;
                        end
                        default: begin
                                {ResultSrcD, MemWriteD, ALUControlD, ALUSrcD, ImmSrcD, RegWriteD, ALUOp, LUIInstr, JumpD, BranchD} = 21'b0;
                        end
                endcase
        end

        always @(ALUOp) begin
                case (ALUOp) 
                        2'b00:
                                ALUControlD = `ALU_ADD;
                        2'b01:
                                ALUControlD = `ALU_SUB;
                        2'b10: begin
                                if (funct3 == `ADDI_FUN3 && op == `ADDI)
                                        ALUControlD = `ALU_ADD;

                                if (funct3 == `ADD_FUN3 && funct7 == `ADD_FUN7)
                                        ALUControlD = `ALU_ADD;
                                
                                if (funct3 == `SUB_FUN3 && funct7 == `SUB_FUN7)
                                        ALUControlD = `ALU_SUB;
                                
                                if (funct3 == `XOR_FUN3)
                                        ALUControlD = `ALU_XOR;
                                
                                if (funct3 == `AND_FUN3)
                                        ALUControlD = `ALU_AND;
                                
                                if (funct3 == `OR_FUN3)
                                        ALUControlD = `ALU_OR;
                                
                                if (funct3 == `SLT_FUN3)
                                        ALUControlD = `ALU_SLT;
                        end
                endcase
        end 

        assign PCSrcE = (BranchE == `branchEq && ZeroE == 1'b1) ? 2'b01:
                        (BranchE == `branchEq && ZeroE == 1'b0) ? 2'b00:
                        (BranchE == `branchNEq && ZeroE == 1'b1) ? 2'b00:
                        (BranchE == `branchNEq && ZeroE == 1'b0) ? 2'b01:
                        (BranchE == `branchLEq && ResSignE == 1'b1) ? 2'b01:
                        (BranchE == `branchLEq && ResSignE == 1'b0) ? 2'b00:
                        (BranchE == `branchGEq && ResSignE == 1'b1) ? 2'b00:
                        (BranchE == `branchGEq && ResSignE == 1'b0) ? 2'b01:
                        (BranchE == `notBranch && JumpE == `jumpRegister) ? 2'b10:
                        (BranchE == `notBranch && JumpE == `jump) ? 2'b01 : 2'b00;
        //     always @(ZeroE,ResSignE,JumpE,BranchE) begin
        // if(BranchE == 3'b000 && JumpE == 2'b00) PCSrcE = 2'b00;
        // else if(BranchE == 3'b001 && ZeroE) PCSrcE = 2'b01;
        // else if(BranchE == 3'b010 && ~ZeroE) PCSrcE = 2'b01;
        // else if(BranchE == 3'b011 && ResSignE) PCSrcE = 2'b01;
        // else if(BranchE == 3'b100 && ~ResSignE) PCSrcE = 2'b01;
        // else if(JumpE == 2'b01) PCSrcE = 2'b10;
        // else if(JumpE == 2'b10) PCSrcE = 2'b01;
        // else PCSrcE = 2'b00;
//     end
endmodule



