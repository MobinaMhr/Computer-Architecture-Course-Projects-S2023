`timescale 1ns/1ns

module pipeFD(clk, rst, en, clr, 
                InstrF, PCF, PCPlus4F, 
                InstrD, PCD, PCPlus4D);
        input clk, rst, en, clr;
        input [31:0] InstrF, PCF, PCPlus4F;
        output [31:0] InstrD, PCD, PCPlus4D;
	// always@(posedge clk)begin

	// 	if(clr)begin
	// 		InstrD = 32'b0;
	// 		PCD = 32'b0;
	// 		PCPlus4D = 32'b0;
	// 	end
	// 	else if(~en)begin
	// 		InstrD = InstrF;
	// 		PCD = PCF;
	// 		PCPlus4D = PCPlus4F;
	// 	end
	// 	else begin
	// 		InstrD = InstrD;
	// 		PCD = PCD;
	// 		PCPlus4D = PCPlus4D;
	// 	end
	// end
        regPipe #(32) instrReg(clk, rst, clr, en, InstrF, InstrD);
        regPipe #(32) pcReg(clk, rst, clr, en, PCF, PCD);
        regPipe #(32) pcPlus4Reg(clk, rst, clr, en, PCPlus4F, PCPlus4D);
endmodule