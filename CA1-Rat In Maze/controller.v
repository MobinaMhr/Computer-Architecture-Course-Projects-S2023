`timescale 1ns/1ns
`define S0 6'd0
`define S1 6'd1
`define S2 6'd2
`define S3 6'd3
`define S4 6'd4
`define S5 6'd5
`define S6 6'd6
`define S7 6'd7
`define S8 6'd8
`define S9 6'd9
`define S10 6'd10
`define S11 6'd11
`define S12 6'd12
`define S13 6'd13
`define S14 6'd14
`define S15 6'd15 

module controller(clk, rst, start, cntReach, empStck, dIn, nxtLoc, curLoc,
                 wr, rd, fail, done, dir, rgLd, pop, push, dOut, adderEn, giveTMem);
        input clk, rst, start, cntReach, empStck , dIn;
        input [7:0] nxtLoc, curLoc;
        
        output wr, rd, fail, done, dir, rgLd, pop, push, dOut, adderEn;
        output reg [7:0] giveTMem;

        wire isDestination = &nxtLoc;

        reg [3:0] ns, ps;
        reg [1:0] dir = 2'b0;
        reg rgLd, wr, dOut, noDir, rd, push, pop, fail, done, adderEn;

        always @(posedge clk, posedge rst) begin
                if (rst)
                        ps <= `S0;
                else
                        ps <= ns;
        end

        always @(ps, start, isDestination, cntReach, noDir, dIn, empStck) begin
                case (ps)
                        `S0: ns= start? `S1: `S0;
                        `S1: ns= `S2;
                        `S2: ns= `S3;
                        `S3: ns= isDestination? `S12: `S6;
                        `S4: ns= noDir? `S8: `S13;
                        `S5: ns= dIn? `S4: `S7;
                        `S6: ns= cntReach? `S4: `S5;       
                        `S7: ns= `S1;
                        `S8: ns= empStck? `S10: `S9;
                        `S9: ns= `S1;
                        `S10: ns= `S11;
                        `S11: ns= `S0;
                        `S12: ns= `S15;
                        `S13: ns= cntReach? `S4: `S5;
                        `S14: ns= empStck? `S0: `S14;
                        `S15: ns= `S14;
                        default: ns = `S0;
                endcase
        end

        always @(ps) begin
                {rgLd, wr, dOut, rd, push, pop, fail, done, adderEn} = 10'b0;
                case(ps)
                        `S1: rgLd = 1'b1;
                        `S3: begin
                                giveTMem = curLoc;
                                wr = 1'b1;
                                dOut = 1'b0;
                        end
                        `S4: begin
                                {noDir, dir} = dir + 1;
                                adderEn = 1'b1;
                                giveTMem = nxtLoc;
                        end
                        `S5: begin
                                rd = 1'b1;
                                giveTMem = nxtLoc;
                        end
                        `S6: begin
                                noDir = 1'b0;
                                dir = 2'b00;
                                adderEn = 1'b1;
                        end
                        `S7: begin
                                giveTMem = curLoc;
                                wr = 1'b1;
                                dOut = 1'b1;
                                push = 1'b1;
                        end
                        `S8: begin
                                giveTMem = curLoc;
                                wr = 1'b1;
                                dOut = 1'b1;
                        end
                        `S9: pop = 1'b1;
                        `S10: fail = 1'b1;
                        `S12: push = 1'b1;
                        `S14: pop = 1'b1;   
                        `S15: done = 1'b1;
                endcase
        end
endmodule