`timescale 1ns/1ns

module ratInMaze(clk, rst, start, run, fail, done, move);
        input clk, rst, start, run;
        output fail, done;
        output [7:0] move;

        wire [7:0] cLoc, nLoc, gTMem;
        wire [1:0] dir;
        wire pop, push, empStck, rgLd, cntRch, rd, wr, wriM, rdfM, addEn;

        controller cntrllr(.clk(clk), .rst(rst), .start(start), .cntReach(cntRch), .empStck(empStck), .dIn(rdfM), .nxtLoc(nLoc), .curLoc(cLoc),
                         .wr(wr), .rd(rd), .fail(fail), .done(done), .dir(dir), .rgLd(rgLd), .pop(pop), .push(push), .dOut(wriM), .adderEn(addEn), .giveTMem(gTMem));
        
        datapath dtpth(.clk(clk), .rst(rst), .rgLd(rgLd), .dir(dir), .push(push), .pop(pop), .done(done), .run(run), .adderEn(addEn),
                         .cntReach(cntRch), .empStck(empStck), .nxtLoc(nLoc), .curLoc(cLoc), .move(move));

        mazeMemory mzmmr(.clk(clk), .loc(gTMem), .dIn(wriM), .rd(rd), .wr(wr),
                         .dOut(rdfM));
endmodule