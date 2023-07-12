`define SW 7'b0100011

`define JAL 7'b1101111

`define LUI 7'b0110111

`define LW 7'b0000011
`define ADDI 7'b0010011
`define SLTI 7'b0010011
`define XORI 7'b0010011
`define ORI 7'b0010011
`define JALR 7'b1100111

`define BRANCH 7'b1100011
`define BEQ 7'b1100011
`define BNW 7'b1100011
`define BLT 7'b1100011
`define BGE 7'b1100011

`define ADD 7'b0110011
`define SUB 7'b0110011
`define SLT 7'b0110011
`define OR 7'b0110011
`define AND 7'b0110011


module controller(clk, rst, Zero, ALUResSign, op, funct7, funct3,
                  PCWrite, AdrSrc, MemWrite, IRWrite, ImmSrc, 
                  RegWrite, ALUControl, ALUSrcA, ALUSrcB, ResultSrc);
        input clk, rst, Zero, ALUResSign;
        input [6:0] op, funct7;
        input [2:0] funct3;
        output reg PCWrite, AdrSrc, MemWrite, IRWrite, RegWrite;
        output reg [2:0] ALUControl, ImmSrc;
        output reg [1:0] ALUSrcA, ALUSrcB, ResultSrc;

        parameter [4:0] IF=5'd0, ID=5'd1;
        parameter [4:0] EX_B=5'd2, EX_R=5'd3, EX_S=5'd4, EX_I=5'd5, EX_J=5'd6, EX_J2=5'd7, EX_U=5'd8;
        parameter [4:0] MEM_S=5'd9, MEM_I=5'd10;
        parameter [4:0] REG_R=5'd11, REG_I_LW=5'd12, REG_I_LOGIC=5'd13, REG_I_JALR=5'd14, REG_J=5'd15;

        reg [4:0] ns, ps;

        always @(ps, op) begin
                ns = IF;
                case (ps)
                        IF : ns = ID;
                        
                        ID : ns = (op == `LW) ? EX_I :
                                (op == `ADDI) ? EX_I :
                                (op == `JALR) ? EX_I :
                                (op == `SW) ? EX_S :
                                (op == `BRANCH) ? EX_B :
                                (op == `ADD) ? EX_R :
                                (op == `LUI) ? EX_U :
                                (op == `JAL) ? EX_J :
                                7'bx;
                        
                        EX_B : ns = IF;
                        EX_R : ns = REG_R;
                        EX_S : ns = MEM_S;
                        EX_I : ns = (op == `LW) ? MEM_I :
                                (op == `ADDI) ? REG_I_LOGIC :
                                (op == `JALR) ? REG_I_JALR : 5'bx;
                        EX_J : ns = REG_J;
                        EX_J2 : ns = IF;
                        EX_U : ns = IF;

                        MEM_S : ns = IF;
                        MEM_I : ns = REG_I_LW;

                        REG_R : ns = IF;
                        REG_I_LW : ns = IF;
                        REG_I_LOGIC : ns = IF;
                        REG_I_JALR : ns = IF;
                        REG_J : ns = EX_J2;

                        default: ns = IF; 
                endcase
        end

        always @(ps, op, funct3, funct7, Zero, ALUResSign) begin
                {AdrSrc, PCWrite, MemWrite, IRWrite, ALUSrcA, ALUSrcB, ALUControl, ResultSrc, RegWrite, ImmSrc} = 16'b0;
                case(ps) 
                        IF : begin
                                AdrSrc = 1'b0;
                                IRWrite = 1'b1;
                                ALUSrcA = 2'b00;
                                ALUSrcB = 2'b10;
                                ALUControl = 3'b000;
                                ResultSrc = 2'b10;
                                PCWrite = 1'b1;
                        end
                        
                        ID : begin
                                ALUSrcA = 2'b01;
                                ALUSrcB = 2'b01;
                                ALUControl = 3'b000;
                                ImmSrc = 3'b010;
                        end

                        EX_B : begin
                                ALUSrcA = 2'b10;
                                ALUSrcB = 2'b00;
                                ALUControl = 3'b001;
                                ResultSrc = 2'b00;
                                PCWrite = (funct3 == 3'b000 && Zero == 1'b1) ? 1'b1 ://beq branches
                                          (funct3 == 3'b001 && Zero == 1'b0) ? 1'b1 :  //bne branches
                                          (funct3 == 3'b100 && ALUResSign == 1'b1) ? 1'b1 :  //blt branches
                                          (funct3 == 3'b101 && ALUResSign == 1'b0) ? 1'b1 : 1'b0; //bge branches
                        end
                        
                        EX_R : begin
                                ALUSrcA = 2'b10;
                                ALUSrcB = 2'b00;
                                ALUControl = (funct3 == 3'b000 && funct7 == 7'b0000000) ? 3'b000 : //ADD
                                             (funct3 == 3'b000 && funct7 == 7'b0100000) ? 3'b001 ://SUB
                                             (funct3 == 3'b010 && funct7 == 7'b0000000) ? 3'b101 : //SLT
                                             (funct3 == 3'b110 && funct7 == 7'b0000000) ? 3'b011 : //OR
                                             (funct3 == 3'b111 && funct7 == 7'b0000000) ? 3'b010 : 3'bx; //AND
                        end
                        
                        EX_S : begin
                                ImmSrc = 3'b001;
                                ALUSrcA = 2'b10;
                                ALUSrcB = 2'b01;
                                ALUControl = 3'b000;
                        end
                        
                        EX_I : begin
                                ImmSrc = 3'b000;
                                ALUSrcA = 2'b10;
                                ALUSrcB = (op == `JALR && funct3 == 3'b000) ? 2'b10 : // JALR
                                        (op == `LW && funct3 == 3'b010) ? 2'b01 : // LW
                                        (op == `ADDI) ? 2'b01 : 2'bxx; // ADDI - ORI - SLTI - XORI - 
                                
                                ALUControl = (op == `ADDI && funct3 == 3'b000) ? 3'b000 : //ADDI
                                             (op == `JALR && funct3 == 3'b000) ? 3'b000 ://JALR
                                             (op == `LW && funct3 == 3'b010) ? 3'b000 : //LW
                                             (op == `ORI && funct3 == 3'b110) ? 3'b011 : //ORI
                                             (op == `XORI && funct3 == 3'b100) ? 3'b100 : //XORI
                                             (op == `SLTI && funct3 == 3'b010) ? 3'b101 : 3'bx; //SLTI
                        end
                        
                        EX_J : begin
                                ALUSrcA = 2'b01;
                                ALUSrcB = 2'b10;
                                ALUControl = 3'b000;
                        end
                        
                        EX_J2 : begin
                                ImmSrc = 3'b011;
                                ALUSrcA = 2'b01;
                                ALUSrcB = 2'b01;
                                ALUControl = 3'b000;
                                ResultSrc = 2'b10;
                                PCWrite = 1'b1;
                        end
                        
                        EX_U : begin
                                ImmSrc = 3'b100;
                                ResultSrc = 3'b011;
                                RegWrite = 1'b1;
                        end

                        MEM_S : begin
                                ResultSrc = 2'b00;
                                AdrSrc = 1'b1;
                                MemWrite = 1'b1;
                        end
                        
                        MEM_I : begin
                                ResultSrc = 2'b00;
                                AdrSrc = 1'b1;
                        end

                        REG_R : begin
                                ResultSrc = 2'b00;
                                RegWrite = 1'b1;
                        end
                        
                        REG_I_LW : begin
                                ResultSrc = 2'b01;
                                RegWrite = 1'b1;
                        end
                        
                        REG_I_LOGIC : begin
                                ResultSrc = 2'b00;
                                RegWrite = 1'b1;
                        end
                        
                        REG_I_JALR : begin
                                ResultSrc = 2'b00;
                                RegWrite = 1'b1;
                        end
                        
                        REG_J : begin
                                ResultSrc = 2'b00;
                                RegWrite = 1'b1;
                        end

                        default: {AdrSrc, PCWrite, MemWrite, IRWrite, ALUSrcA, 
                                  ALUSrcB, ALUControl, ResultSrc, RegWrite, ImmSrc} = 16'b0;
                endcase
        end

        always @(posedge clk, posedge rst) begin
                if (rst) begin
                        ps <= IF;
                end
                else begin
                        ps <= ns;
                end
        end
endmodule
