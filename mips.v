module mips( clk, rst );
   input   clk;
   input   rst;
   
   // wire 		     RFWr;
   // wire 		     DMWr;
   // wire 		     PCWr;
   // wire 		     IRWr;
   // wire [1:0]  ExtOp;
   // wire [1:0]  ALUOp;
   // wire [1:0]  NPCOp;
   // wire 		     BSel;
   // wire 		     Zero;
   
   // assign Op = instr[31:26];
   // assign Funct = instr[5:0];
   // assign rs = instr[25:21];
   // assign rt = instr[20:16];
   // assign rd = instr[15:11];
   // assign Imm16 = instr[15:0];
   // assign IMM = instr[25:0];
   	
//PC	

	wire [31:0] pcOut;//PC输出
		wire [1:0] pcSel;//跳转和分支选择
		wire [31:0] pcAddr;//PC跳转
		
//IM	
	wire [9:0] imAdr;//指令地址
	wire [31:0] imOut;//指令
//IF/ID
	wire [31:0] instr;
	
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
	// wire 		MemR;						//读存储器
	wire 		Mem2R;						//数据存储器到寄存器堆
	wire 		RegW;						//寄存器堆写入数据
	wire		Alusrc;						//运算器操作数选择
	wire [1:0]		ExtOp;						//位扩展/符号扩展选择
	wire [4:0]  Aluctrl;						//Alu运算选择
	wire shift;//移位指令选择
	wire [4:0] shamt;//移位字段
//Alu
	wire [31:0] aluDataIn1;//ALu输入1 来自rs或rt
	wire [31:0] aluDataIn2;//ALU输入2 来自扩展数或寄存器
	wire [31:0]	aluDataOut;//ALU输出
	wire 		zero;
	
	assign pcSel[1] = jump[0]||jump[1];
	assign pcSel[0] = ((Branch[0]&&zero)||(Branch[1]&&!zero)) ? 1 : 0;//beq与bnq分支
	
	assign pcAddr = (jump==2'b11) ? RfDataOut1 : (jump==2'b01 || jump==2'b10) ? {pcOut[31:28],imOut[25:0],2'b00} : extDataOut;
	
	
//PC块实例化	
    PcUnit U_PC(.PC(pcOut),.PcReSet(rst),.PcSel(pcSel),.Clk(clk),.Address(pcAddr));
	// PC PC( .clk(clk), .rst(Reset), PCWr, NPC, PC );
	assign imAdr = pcOut[11:2];
	
//指令寄存器实例化	
	im_4k U_IM(.dout(imOut),.addr(imAdr));

//IF/ID流水线寄存器 IF_ID(pcIn,imIn,clk,pcOut,imOut,rst)
	IF_ID U_IF_ID(.pcIn(pcOut),.imIn(imOut),.clk(clk),.imOut(instr),.rst(rst));
//拆分指令
	assign op = instr[31:26];
	assign funct = instr[5:0];
	assign rs = instr[25:21];
	assign rt = instr[20:16];
	assign rd = (jump==2'b10)? 5'b11111 : (RegDst==0)?instr[20:16]:instr[15:11]; 
	assign extDataIn = (shift==1) ? {{11{1'b0}},shamt} : instr[15:0];
	assign shamt = instr[10:6];
		                
//寄存器堆实例化
	RF U_RF(.RD1(RfDataOut1),.RD2(RfDataOut2),.clk(clk),.WD(RfDataIn)
			  ,.RFWr(RegW),.A3(rd),.A1(rs),.A2(rt));
//控制器实例化	
	Ctrl U_Ctrl(.jump(jump),.RegDst(RegDst),.Branch(Branch),.Mem2R(Mem2R)
				,.MemW(MemW),.RegW(RegW),.Alusrc(Alusrc),.ExtOp(ExtOp),.Aluctrl(Aluctrl)
				,.OpCode(op),.funct(funct),.shift(shift));
				
//扩展器实例化	
	EXT U_EXT(.Imm32(extDataOut),.Imm16(extDataIn),.ExtOp(ExtOp));
	
	assign aluDataIn1 = (shift==1)? RfDataOut2 : RfDataOut1;
	assign aluDataIn2 = (Alusrc==0) ? RfDataOut2:extDataOut;
	
//ALU实例化	
	alu alu(.C(aluDataOut),.Zero(zero),.A(aluDataIn1),.B(aluDataIn2),.ALUOp(Aluctrl));
	
	
	assign RfDataIn = (jump==2'b10)? pcOut+3'b100 :  (Mem2R==1)?dmDataOut:aluDataOut;
	
	
//DM实例化

	assign dmDataAdr = aluDataOut[11:2];
	dm_4k U_dm(.dout(dmDataOut),.addr(dmDataAdr),.din(RfDataOut2),.DMWr(MemW),.clk(clk),.rst(rst));
endmodule
   // PC U_PC (
      // .clk(clk), .rst(rst), .PCWr(PCWr), .NPC(NPC), .PC(PC)
   // ); 
   
   // im_4k U_IM ( 
      // .addr(PC[9:2]) , .dout(im_dout)
   // );
   
    
   // RF U_RF (
      // .A1(rs), .A2(rt), .A3(A3), .WD(WD), .clk(clk), 
      // .RFWr(RFWr), .RD1(RD1), .RD2(RD2)
   // );
   
  