module registerFile(clk, rst, A1, A2, A3, WE, WD, RD1, RD2);
        input clk, rst;
        input [19:15] A1;
        input [24:20] A2;
        input [11:7] A3;
        input WE;
        input [31:0] WD;
        output [31:0] RD1, RD2;
        integer i;
        
        reg [31:0] registers [0:31];
        initial begin
                registers[0] <= 32'b0; // ZERO register
        end

        always @(posedge clk, posedge rst) begin
                if (rst) begin
                        for (i = 0; i < 32; i = i + 1)
                                registers[i] <= 32'b0;
                end
                else if (WE && A3 != 5'b0) begin
                        registers[A3] <= WD;
                end
        end

        assign RD1 = registers[A1];
        assign RD2 = registers[A2];
endmodule