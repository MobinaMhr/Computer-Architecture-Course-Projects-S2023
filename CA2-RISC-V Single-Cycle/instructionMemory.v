module instructionMemory(A, RD);
        input [31:0] A;
        output [31:0] RD;
        wire [31:0] address;

        reg [31:0] memory [0:16384]; // 2^14 
        
        initial begin
                $readmemb("instructions.txt", memory);
        end

        assign address = {2'b0, A[31:2]};
        assign RD = memory[address];
endmodule