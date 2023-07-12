module RISCV_TB();
        reg clk, rst;

        RISCV cpu(clk, rst);

        always #5 clk <= ~clk;

        initial begin
                clk = 1'b0;
                rst = 1'b1;
                #10 rst = 1'b0;

                #3000 $stop;
        end
endmodule