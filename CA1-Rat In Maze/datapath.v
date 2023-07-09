`timescale 1ns/1ns

module datapath(clk, rst, rgLd, dir, push, pop, done, run, adderEn,
                 cntReach, empStck, nxtLoc, curLoc, move);
        input clk, rst, rgLd, push, pop, done, run, adderEn;
        input [1:0] dir;
        output [7:0] nxtLoc, curLoc, move;
        output cntReach, empStck;

        wire sl, co, muxSl1, muxSl2;
        wire [3:0] res, toAdd, addTo, tmp, negOne;
        wire [7:0] popedLoc, mux1Out, mux2Out, mux3Out, inMux1, inMux2;

        
        assign tmp = addTo + dir[0];
        assign sl = ^dir;
        assign toAdd = dir[0]? 4'b1: negOne;
        assign cntReach = (tmp == 4'b0);
        assign addTo = sl? curLoc[7:4]: curLoc[3:0];
        assign muxSl1 = adderEn && ~sl;
        assign muxSl2 = adderEn && sl;
        assign inMux1 = {curLoc[7:4], res};
        assign inMux2 = {res, curLoc[3:0]};
        
        twosComplement neg1(.in(4'b1), .out(negOne));
        mux2To1 mux1(.in0(nxtLoc), .in1(inMux1), .sl(muxSl1), .out(mux1Out));
        mux2To1 mux2(.in0(mux1Out), .in1(inMux2), .sl(muxSl2), .out(mux2Out));
        mux2To1 mux3(.in0(mux2Out), .in1(popedLoc), .sl(pop), .out(mux3Out));
        mux2To1 mux4(.in0(mux3Out), .in1(8'h00), .sl(rst), .out(nxtLoc));

        reg4B xLoc(.clk(clk), .rst(rst), .ld(rgLd), .dataIn(nxtLoc[7:4]), .dataOut(curLoc[7:4]));
        reg4B yLoc(.clk(clk), .rst(rst), .ld(rgLd), .dataIn(nxtLoc[3:0]), .dataOut(curLoc[3:0]));

        adder add(.a(addTo), .b(toAdd), .ci(1'b0), .en(adderEn), .co(co), .sum(res));
        stckQue stkQ(.clk(clk), .rst(rst), .locIn(curLoc), .push(push), .pop(pop), .done(done), .run(run), .locOut(popedLoc), .move(move), .empStck(empStck));

        always @(curLoc) begin
                $display("Mouse Location --> X:%d   Y:%d", curLoc[7:4], curLoc[3:0]);
        end
endmodule