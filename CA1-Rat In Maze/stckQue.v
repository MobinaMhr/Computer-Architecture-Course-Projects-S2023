`timescale 1ns/1ns
`define STACK 1'b0
`define QUEUE 1'b1

module stckQue(clk, rst, locIn, push, pop, done, run, locOut, move, empStck);
        input clk, rst, push, pop, done, run;
        input [7:0] locIn;
        output [7:0] locOut;
        output reg [7:0] move; 
        output empStck;

        reg [7:0] headPointer = 8'b0;
        reg [7:0] mainPointer = 8'b0;
        reg pPopType = `STACK; 
        assign empStck = (pPopType == `STACK)? (headPointer == 8'b0): (mainPointer == headPointer);

        reg [7:0] stackMem [0:255];
        reg [7:0] locOut;
        integer i = 0;

        always @(posedge clk, posedge rst) begin
                if (done) begin 
                        pPopType = `QUEUE;
                        mainPointer = 8'b1;
                        $display("--Done signal activated--");
                end

                else begin 
                        if (rst) begin
                                headPointer = 8'b0;
                                mainPointer = 8'b0;
                                pPopType = `STACK;
                                for (i = 0; i < 256; i = i + 1)
                                        stackMem[i] <= 8'h00;
                        end

                        else if (push) begin
                                headPointer = headPointer + 1;
                                mainPointer = headPointer;
                                stackMem[mainPointer] = locIn;
                        end

                        else if (pop && headPointer > 0 && pPopType == `QUEUE && run) begin
                                locOut = stackMem[mainPointer];
                                mainPointer = mainPointer + 1;
                                move = locOut;
                                $display("Path --> X:%d   Y:%d", locOut[7:4], locOut[3:0]);
                        end

                        else if (pop && headPointer > 0 && pPopType == `STACK) begin 
                                locOut = stackMem[mainPointer];
                                headPointer = headPointer - 1;    
                                mainPointer = headPointer;
                        end
                end
        end
endmodule