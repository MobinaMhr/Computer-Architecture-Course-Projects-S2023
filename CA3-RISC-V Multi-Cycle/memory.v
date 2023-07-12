module memory(clk, rst, A, WE, WD, RD);
        input clk, rst;
        input [31:0] A;
        input WE;
        input [31:0] WD;
        output [31:0] RD;
        wire [31:0] address;
        integer i;

        reg [31:0] memory [0:16384]; // 2^14

        initial begin
                $readmemh("data.txt", memory);
        end

        assign address = {2'b0, A[31:2]};

        always @(posedge clk, posedge rst) begin
                if (WE) begin
                        memory[address] <= WD;
                end
        end
        
        assign RD = memory[address];
endmodule