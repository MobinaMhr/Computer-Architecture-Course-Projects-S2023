`timescale 1ns/1ns

module reg4B(clk, rst, ld, dataIn, dataOut);
        input clk, rst, ld;
        input [3:0] dataIn;
        output [3:0] dataOut;
        reg [3:0] savedData;
        always @(posedge clk, posedge rst) begin 
                if (rst) begin 
                        savedData <= 4'h0;
                end

                else if (ld) begin 
                        savedData <= dataIn;
                end

                else
                        savedData <= dataOut;
        end

        assign dataOut = savedData;
endmodule