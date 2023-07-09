`timescale 1ns/1ns

module RISCV_TB();
        reg clk, rst;

        RISCV cpu(clk, rst);

        always #5 clk <= ~clk;

        initial begin
                clk = 1'b0;
                rst = 1'b1;
                #10 rst = 1'b0;

                #1300 $stop;
        end
endmodule