module mips( clk, rst );
   input   clk;
   input   rst;
   
//PC	

	wire [31:0] pcOut;//PC输出
	wire [1:0] pcSel;//跳转和分支选择
	wire [31:0] pcAddr;//PC跳转
//流水线相关
//IM	
	wire [9:0] imAdr;//指令地址
	wire [31:0] imOut;//指令
//IF/ID
	wire [31:0] instr;
	wire [31:0] IF_PcOut;
	wire IF_Zero;//提前判断branch
	wire [31:0] ExtAddr;//符号扩展后的地址
	wire [4:0] RfRd;
	wire RfWr;
//ID_EX
	wire [31:0] ID_RegPcIn;wire [31:0] ID_RegInStr;wire [31:0] ID_RegRegOut1;wire [31:0] ID_RegRegOut2; wire [31:0] ID_RegExtOut;
	wire [1:0] ID_RegJump;wire [4:0] ID_RegRd;wire [4:0] ID_RegRs;wire [4:0] ID_RegRt;wire [1:0] ID_RegBranch;wire ID_RegMem2R;wire ID_RegMemW;wire ID_RegRegW;
	wire ID_RegAluSrc;wire [1:0] ID_RegExtOp;wire [4:0] ID_RegAluCtrl; wire ID_RegShift;
//EX_MEM
	wire [31:0] EX_RegExtPc; wire [31:0] EX_RegAluOut;wire EX_RegZero;wire [31:0] EX_RegRtOut;wire [4:0] EX_RegRd;
	wire [1:0] EX_RegBranch; wire EX_RegMemW; wire EX_RegRegW; wire EX_RegMem2R;
//MEW_WB
wire [9:0] MEM_RegDmAddr; wire [31:0] MEM_RegDmOut;wire [31:0] MEM_RegAluOut;
wire [4:0] MEM_RegRd; wire MEM_RegRegW;wire MEM_RegMem2R;
wire [31:0] MEM_RfDataIn;
//旁路
wire [1:0] FORWARD_Out1;
wire [1:0] FORWARD_Out2;//旁路选择器输入1和2

//RF 

	wire [4:0] rd,rs,rt;//读写寄存器输入
	wire [31:0] RfDataIn;//寄存器输入
	wire [31:0] RfDataOut1,RfDataOut2;//寄存器输出
	
//Extender

	wire [15:0] extDataIn;//扩展器输入
	wire [31:0] extDataOut;//扩展器输出
	
//DMem

	wire [9:0] dmDataAdr;//数据地址
	wire [31:0] dmDataOut;//数据输出
	wire 		     MemW;//写使能
	
//Ctrl
	wire [5:0]		op;
	wire [5:0]		funct;
	wire [1:0]	jump;						//指令跳转
	wire 		RegDst;						//rt或rd
	wire [1:0]		Branch;						//分支
	wire 		Mem2R;						//数据存储器到寄存器堆
	wire 		RegW;						//寄存器堆写入数据
	wire		Alusrc;						//运算器操作数选择
	wire [1:0]		ExtOp;						//位扩展/符号扩展选择
	wire [4:0]  Aluctrl;						//Alu运算选择
	wire shift;//移位指令选择
	wire [4:0] shamt;//移位字段
	wire nop;
	
//Alu
	wire [31:0] aluDataIn1;//ALu输入1 来自rs或rt
	wire [31:0] aluDataIn2;//ALU输入2 来自扩展数或寄存器
	wire [31:0]	aluDataOut;//ALU输出
	wire 		zero;
	
//PC块实例化	
    PcUnit U_PC(.PC(pcOut),.PcReSet(rst),.PcSel(pcSel),.Clk(clk),.Address(pcAddr));
	assign imAdr = pcOut[11:2];
	
//指令寄存器实例化	
	im_4k U_IM(.dout(imOut),.addr(imAdr));

//IF/ID流水线寄存器 IF_ID(pcIn,imIn,clk,pcOut,imOut,rst)
	IF_ID U_IF_ID(.pcIn(pcOut),.imIn(imOut),.clk(clk),.imOut(instr),.rst(rst),.pcOut(IF_PcOut));
//拆分指令
	assign nop = (instr==32'h00000000) ? 1 : 0;
	assign op = instr[31:26];
	assign funct = instr[5:0];
	assign rs = instr[25:21];
	assign rt = instr[20:16];
	assign rd = (RegDst==0)?instr[20:16]:instr[15:11];
	assign extDataIn = (shift==1) ? {{11{1'b0}},shamt} : instr[15:0];
	assign shamt = instr[10:6];
	assign RfRd = (jump==2'b10)? 5'b11111 : MEM_RegRd;	                
//寄存器堆实例化
	assign RfDataIn = (jump==2'b10) ? IF_PcOut+3'b100 : MEM_RfDataIn;
	assign RfWr = (jump==2'b10) ? 1 : MEM_RegRegW;
	RF U_RF(.RD1(RfDataOut1),.RD2(RfDataOut2),.clk(clk),.WD(RfDataIn)
			  ,.RFWr(RfWr),.A3(RfRd),.A1(rs),.A2(rt));
	
	//跳转相关
	assign IF_Zero=(RfDataOut1==RfDataOut2) ? 1 : 0;//Branch判断提前
	assign pcSel[1] = jump[0]||jump[1];//第一位判断是否是跳转指令
	assign pcSel[0] = ((Branch[0]&&IF_Zero)||(Branch[1]&&!IF_Zero)) ? 1 : 0;//beq与bnq分支
	assign ExtAddr = {{16{instr[15]}}, instr[15:0]};//符号扩展地址偏移
	assign pcAddr = (jump==2'b11) ? RfDataOut1 :  //jr指令
	(jump==2'b01 || jump==2'b10) ? {IF_PcOut[31:28],instr[25:0],2'b00} //j 和 jal指令
	: ExtAddr; //branch指令
	
//控制器实例化	
	Ctrl U_Ctrl(.jump(jump),.RegDst(RegDst),.Branch(Branch),.Mem2R(Mem2R)
				,.MemW(MemW),.RegW(RegW),.Alusrc(Alusrc),.ExtOp(ExtOp),.Aluctrl(Aluctrl)
				,.OpCode(op),.funct(funct),.shift(shift),.nop(nop));
				//扩展器实例化	
	EXT U_EXT(.Imm32(extDataOut),.Imm16(extDataIn),.ExtOp(ExtOp));
				
//ID\EX实例化
	ID_EX U_ID_EX(.clk(clk),.rst(rst),.PcIn(IF_PcOut),.Instr(instr),.RegOut1(RfDataOut1),.RegOut2(RfDataOut2),.ExtOut(extDataOut),//输入
.Rd(rd),.Rt(rt),.Rs(rs),.Jump(jump),.Branch(Branch),.Mem2R(Mem2R),.MemW(MemW),.RegW(RegW),.AluSrc(Alusrc),.ExtOp(ExtOp),.AluCtrl(Aluctrl),.Shift(shift),//输入
.RegPcIn(ID_RegPcIn),.RegInStr(ID_RegInStr),.RegRegOut1(ID_RegRegOut1),.RegRegOut2(ID_RegRegOut2),.RegExtOut(ID_RegExtOut),//输出
.RegRd(ID_RegRd),.RegRt(ID_RegRt),.RegRs(ID_RegRs),.RegJump(ID_RegJump),.RegBranch(ID_RegBranch),.RegMem2R(ID_RegMem2R),.RegMemW(ID_RegMemW),//输出
.RegRegW(ID_RegRegW),.RegAluSrc(ID_RegAluSrc),.RegExtOp(ID_RegExtOp),.RegAluCtrl(ID_RegAluCtrl),.RegShift(ID_RegShift)//输出
);
	//流水线 旁路单元
	FORWARD_UNIT U_FOR_UNIT(.rst(rst),.EX_RegW(EX_RegRegW),.EX_RegRd(EX_RegRd),.ID_RegRs(ID_RegRs),.ID_RegRt(ID_RegRt),
	.MEM_RegW(MEM_RegRegW),.MEM_RegRd(MEM_RegRd),
	.FORWARD_Out1(FORWARD_Out1),.FORWARD_Out2(FORWARD_Out2)
	);
	
	//流水线 立即数与移位选择器
	assign aluDataIn1 = (FORWARD_Out1==2'b00) ? 
	((ID_RegShift==1)? ID_RegRegOut2 : ID_RegRegOut1):
	(FORWARD_Out1==2'b10) ? EX_RegAluOut : //10旁路返回ex结果值
	(FORWARD_Out1==2'b01) ? RfDataIn : 0;//01旁路返回mem写回值
	assign aluDataIn2 = (FORWARD_Out2==2'b00) ?
	((ID_RegAluSrc==0) ? ID_RegRegOut2:ID_RegExtOut) :
	(FORWARD_Out2==2'b10) ? EX_RegAluOut : //10旁路返回ex结果值
	(FORWARD_Out2==2'b01) ? RfDataIn : 0;//01旁路返回mem写回值
	
//ALU实例化	
	alu alu(.C(aluDataOut),.Zero(zero),.A(aluDataIn1),.B(aluDataIn2),.ALUOp(ID_RegAluCtrl));
	
//EX_MEM实例化
	EX_MEM U_EX_MEM(.clk(clk),.rst(rst),.ExtPc(pcAddr),.AluOut(aluDataOut),.Zero(zero),.RtOut(ID_RegRegOut2),.Rd(ID_RegRd),//输入
	.Branch(ID_RegBranch),.MemW(ID_RegMemW),.RegW(ID_RegRegW),.Mem2R(ID_RegMem2R),//输入
.RegExtPc(EX_RegExtPc),.RegAluOut(EX_RegAluOut),.RegZero(EX_RegZero),.RegRtOut(EX_RegRtOut),//输出
.RegRd(EX_RegRd),.RegBranch(EX_RegBranch),.RegMemW(EX_RegMemW),.RegRegW(EX_RegRegW),.RegMem2R(EX_RegMem2R) //输出
);

//DM实例化
	assign dmDataAdr = EX_RegAluOut[11:2];
	dm_4k U_dm(.dout(dmDataOut),.addr(dmDataAdr),.din(EX_RegRtOut),.DMWr(EX_RegMemW),.clk(clk),.rst(rst));
	
	// assign RfDataIn =(EX_RegMem2R==1)?dmDataOut:EX_RegAluOut;
//MEM_WB实例化
	MEM_WB U_MEM_WB(.rst(rst),.clk(clk),.DmAddr(dmDataAdr),.DmOut(dmDataOut),.AluOut(EX_RegAluOut),
	.Rd(EX_RegRd),.RegW(EX_RegRegW),.Mem2R(EX_RegMem2R),
	.RegDmAddr(MEM_RegDmAddr),.RegDmOut(MEM_RegDmOut),.RegAluOut(MEM_RegAluOut),.RegRd(MEM_RegRd),.RegRegW(MEM_RegRegW),.RegMem2R(MEM_RegMem2R)
); 
	// assign RfDataIn = (ID_RegJump==2'b10)? pcOut+3'b100 :  (Mem2R==1)?dmDataOut:aluDataOut;
	assign MEM_RfDataIn = (MEM_RegMem2R==1)?MEM_RegDmOut:MEM_RegAluOut;//选择写回的数据 需要添加jr和jal
	
endmodule




  