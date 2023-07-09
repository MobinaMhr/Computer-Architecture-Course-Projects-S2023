`timescale 1ns/1ns

module mazeMemory(clk, loc, dIn, rd, wr, dOut);
        input clk, dIn, rd, wr;
        input [7:0] loc;
        output dOut;

        reg [3:0] x, y;
        reg [0:15] map [0:15];
        reg dOut;

        initial begin
                $readmemh("map.txt", map);
        end

        always @(posedge clk, posedge rd) begin
                dOut <= 1'b0;
                {y, x} = loc;

                if (rd) begin 
                        dOut <= map[x][y];
                end

                else if (wr) begin 
                        map[x][y] <= dIn;
                end                
        end
endmodule