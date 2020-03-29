module EX_MEM(clk,rst,ExtPc,AluOut,Zero,RtOut,Rd,Branch,MemW,RegW,Mem2R,
RegExtPc,RegAluOut,RegZero,RegRtOut,RegRd,RegBranch,RegMemW,RegRegW,RegMem2R
);
	input clk; input rst; 
	input [31:0] ExtPc;input [31:0] AluOut;input Zero;input [31:0] RtOut;
	input [4:0] Rd;input [1:0] Branch; input MemW; input RegW; input Mem2R;
	
	output reg [31:0] RegExtPc; output reg [31:0] RegAluOut;output reg RegZero;output reg [31:0] RegRtOut;
	output reg [4:0] RegRd;output reg [1:0] RegBranch; output reg RegMemW; output reg RegRegW; output reg RegMem2R;
	
	always @( rst or posedge clk)
	begin
		if (rst)
		begin
			RegExtPc=0;RegAluOut=0;RegZero=0;RegRtOut=0;RegRd=0;
			RegBranch=0;RegMemW=0;RegRegW=0;RegMem2R=0;
		end
		else
		begin
			RegExtPc=ExtPc;RegAluOut=AluOut;RegZero=Zero;RegRtOut=RtOut;RegRd=Rd;
			RegBranch=Branch;RegMemW=MemW;RegRegW=RegW;RegMem2R=Mem2R;
		end
	end

endmodule