//(.jump(jump),.RegDst(RegDst),.Branch(Branch),.Mem2R(Mem2R),.MemW(MemW),.RegW(RegW),.Alusrc(Alusrc),.ExtOp(ExtOp),.Aluctrl(Aluctrl),.OpCode(op),.funct(funct),.shift(shift));
module ID_EX(clk,rst,PcIn,Instr,RegOut1,RegOut2,ExtOut,//输入
Jump,Rd,Branch,Mem2R,MemW,RegW,AluSrc,ExtOp,AluCtrl,Shift,//输入
RegPcIn,RegInStr,RegRegOut1,RegRegOut2,RegExtOut,//输出
RegJump,RegRd,RegBranch,RegMem2R,RegMemW,RegRegW,RegAluSrc,RegExtOp,RegAluCtrl,RegShift//输出
);
	input clk;input rst;
	input [31:0] PcIn;input [31:0] Instr;input [31:0] RegOut1;
	input [31:0] RegOut2;input [31:0] ExtOut;
	input [1:0] Jump;input [4:0] Rd;input [1:0] Branch;
	input Mem2R;input MemW;input RegW;
	input AluSrc;input [1:0] ExtOp;input [4:0] AluCtrl; input Shift;
	
	output reg [31:0] RegPcIn;output reg [31:0] RegInStr;output reg [31:0] RegRegOut1;
	output reg [31:0] RegRegOut2;output reg [31:0] RegExtOut;
	output reg [1:0] RegJump;output reg [4:0] RegRd;output reg [1:0] RegBranch;
	output reg RegMem2R;output reg RegMemW;output reg RegRegW;
	output reg RegAluSrc;output reg [1:0] RegExtOp;output reg [4:0] RegAluCtrl; output reg RegShift;
	
	always @ (rst or posedge clk)
	begin
		if (rst)
		begin
			RegPcIn=0;RegInStr=0;RegRegOut1=0;
			RegRegOut2=0;RegExtOut=0;
			RegJump=0;RegRd=0;RegBranch=0;
			RegMem2R=0;RegMemW=0;RegRegW=0;
			RegAluSrc=0;RegExtOp=0;RegAluCtrl=0;RegShift=0;
		end
		else
		begin
			RegPcIn=PcIn;RegInStr=Instr;RegRegOut1=RegOut1;
			RegRegOut2=RegOut2;RegExtOut=ExtOut;
			RegJump=Jump;RegRd=Rd;RegBranch=Branch;
			RegMem2R=Mem2R;RegMemW=MemW;RegRegW=RegW;
			RegAluSrc=AluSrc;RegExtOp=ExtOp;RegAluCtrl=AluCtrl;RegShift=Shift;
		end
	end
endmodule
	
	
	