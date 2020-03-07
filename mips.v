module mips( clk, rst );
   input   clk;
   input   rst;
   
   // wire 		     RFWr;
   // wire 		     DMWr;
   // wire 		     PCWr;
   // wire 		     IRWr;
   // wire [1:0]  EXTOp;
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

	wire [31:0] pcOut;


//IM	
	wire [9:0]  imAdr;
	wire [31:0] imOut;
	
//GPR
	wire [4:0] gprWeSel,gprReSel1,gprReSel2;
	wire [31:0] gprDataIn;
	
	wire [31:0] gprDataOut1,gprDataOut2;
	
//Extender

	wire [15:0] extDataIn;
	wire [31:0] extDataOut;
	
//DMem

	wire [9:0]  dmDataAdr;
	wire [31:0] dmDataOut;
	
//Ctrl
	
	wire [5:0]		op;
	wire [5:0]		funct;
	wire 		jump;						//ָ����ת
	wire 		RegDst;						
	wire 		Branch;						//��֧
	wire 		MemR;						//���洢��
	wire 		Mem2R;						//���ݴ洢�����Ĵ�����
	wire 		MemW;						//д���ݴ洢��
	wire 		RegW;						//�Ĵ�����д������
	wire		Alusrc;						//������������ѡ��
	wire [1:0]		ExtOp;						//λ��չ/������չѡ��
	wire [1:0]  Aluctrl;						//Alu����ѡ��

//Alu
	wire [31:0] aluDataIn2;
	wire [31:0]	aluDataOut;
	wire 		zero;
	
	assign pcSel = ((Branch&&zero)==1)?1:0;
	
	
//PC��ʵ����	
    PcUnit PcUnit(.PC(pcOut),.PcReSet(rst),.PcSel(pcSel),.Clk(clk),.Adress(extDataOut));
	// PC PC( .clk(clk), .rst(Reset), PCWr, NPC, PC );
	assign imAdr = pcOut[11:2];
//ָ��Ĵ���ʵ����	
	im_4k im_4k(.dout(imOut),.addr(imAdr));
	
	assign op = imOut[31:26];
	assign funct = imOut[5:0];
	assign gprReSel1 = imOut[25:21];
	assign gprReSel2 = imOut[20:16];
	
	
	assign gprWeSel = (RegDst==1)?imOut[20:16]:imOut[15:11];

	assign extDataIn = imOut[15:0];
		                
//�Ĵ�����ʵ����
	RF RF(.RD1(gprDataOut1),.RD2(gprDataOut2),.clk(Clk),.WD(gprDataIn)
			  ,.RFWr(RegW),.A3(gprWeSel),.A1(gprReSel1),.A2(gprReSel2));
//������ʵ����	
	Ctrl Ctrl(.jump(jump),.RegDst(RegDst),.Branch(Branch),.MemR(MemR),.Mem2R(Mem2R)
				,.MemW(MemW),.RegW(RegW),.Alusrc(Alusrc),.ExtOp(ExtOp),.Aluctrl(Aluctrl)
				,.OpCode(op),.funct(funct));
				
//��չ��ʵ����	
	EXT EXT(.Imm32(extDataOut),.Imm16(extDataIn),.EXTOp(ExtOp));
	
	assign aluDataIn2 = (Alusrc==1)?extDataOut:gprDataOut2;
	
//ALUʵ����	
	alu alu(.C(aluDataOut),.Zero(zero),.A(gprDataOut1),.B(aluDataIn2),.ALUOp(Aluctrl));
	
	
	assign gprDataIn = (Mem2R==1)?dmDataOut:aluDataOut;
	
	
//DMʵ����

	assign dmDataAdr = aluDataOut[9:0];
	dm_4k dm_4k(.dout(dmDataOut),.addr(dmDataAdr),.din(gprDataOut2),.DMWr(MemW),.clk(Clk));
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
   
  