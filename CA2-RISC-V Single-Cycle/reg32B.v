module reg32B(clk, rst, dataIn, dataOut);
        input clk, rst;
        input [31:0] dataIn;
        output [31:0] dataOut;
        reg [31:0] savedData;
        
        always @(posedge clk, posedge rst) begin 
                if (rst) begin 
                        savedData = 32'b0;
                end
                else begin
                        savedData = dataIn;
                end
        end

        assign dataOut = savedData;
endmodule