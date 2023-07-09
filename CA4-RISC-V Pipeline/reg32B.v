`timescale 1ns/1ns

module reg32B(clk, rst, en, dataIn, dataOut);
        input clk, rst, en;
        input [31:0] dataIn;
        output [31:0] dataOut;
        reg [31:0] savedData;
        
        always @(posedge clk, posedge rst) begin 
                if (rst) 
                        savedData = 32'b0;

                else if (en)
                        savedData = dataIn;
        end

        assign dataOut = savedData;
endmodule