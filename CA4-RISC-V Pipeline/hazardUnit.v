module hazardUnit(rst, RegWriteWHazard, RdWHazard, RegWriteMHazard, RdMHazard, ResultSrcEHazard, PCSrcEHazard,
                 Rs1EHazard, Rs2EHazard, RdEHazard, Rs2DHazard, Rs1DHazard,
                        FlushE, FlushD, StallD, StallF, ForwardBE, ForwardAE);
        input RegWriteWHazard, RegWriteMHazard;
        input ResultSrcEHazard;
        input [1:0] PCSrcEHazard;
        output reg FlushE, FlushD, StallD, StallF;
        output reg [1:0] ForwardBE, ForwardAE;
      //   input [4:0] Rs1EHazard, Rs2EHazard;
        input [4:0] RdWHazard, RdMHazard, Rs1EHazard, Rs2EHazard, RdEHazard, Rs2DHazard, Rs1DHazard;
      input rst;
reg lwStall;

always @(posedge rst) {lwStall, StallF, StallD, ForwardAE, ForwardBE} = 7'b0000_000;
always @(Rs1DHazard, Rs2DHazard, Rs1EHazard, Rs2EHazard, RdEHazard, ResultSrcEHazard, RdMHazard, RegWriteMHazard, RdWHazard, RegWriteWHazard) begin
    
    {lwStall, StallF, StallD, ForwardAE, ForwardBE} = 7'b0000_000;

    if(((Rs1EHazard == RdMHazard) && RegWriteMHazard) && (Rs1EHazard != 5'b00000))
        ForwardAE = 2'b10;
    else if (((Rs1EHazard == RdWHazard) && RegWriteWHazard) && (Rs1EHazard != 5'b00000))
        ForwardAE = 2'b01;
    else 
        ForwardAE = 2'b00;

    if(((Rs2EHazard == RdMHazard) && RegWriteMHazard) && (Rs2EHazard != 5'b00000))
        ForwardBE = 2'b10;
    else if (((Rs2EHazard == RdWHazard) && RegWriteWHazard) && (Rs2EHazard != 5'b00000))
        ForwardBE = 2'b01;
    else 
        ForwardBE = 2'b00;

    if (((Rs1DHazard == RdEHazard) || (Rs2DHazard == RdEHazard)) && (ResultSrcEHazard == 2'b01))
        {lwStall,StallD, StallF} = 3'b111;
        
end

assign FlushD = |PCSrcEHazard;
assign FlushE = (lwStall || |PCSrcEHazard);
    
endmodule


// Rs1EHazard, RdMHazard, RegWriteMHazard, RdWHazard, RegWriteWHazard, Rs2EHazard, Rs1DHazard, RdEHazard, Rs2DHazard, ResultSrcEHazard