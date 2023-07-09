`timescale 1ns/1ns

module regPipe(clk, rst, clr, en, dataIn, dataOut);
        parameter SIZE;
        input clk, rst, clr, en;
        input [SIZE-1:0] dataIn;
        output [SIZE-1:0] dataOut;
        reg [SIZE-1:0] savedData;
        
        always @(posedge clk, posedge rst) begin 
                if (rst) 
                        savedData = 0;
                else if (clr)
                        savedData = 0;
                else if (en)
                        savedData = dataIn;
        end

        assign dataOut = savedData;
endmodule