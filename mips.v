`include "instruction_def.v"
`include "ctrl_encode_def.v"
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

	wire [31:0] pcOut;//PC���

//IM	
	wire [9:0] imAdr;//ָ���ַ
	wire [31:0] imOut;//ָ��
	
//RF 

	wire [4:0] rd,rs,rt;//��д�Ĵ�������
	wire [31:0] RfDataIn;//�Ĵ�������
	wire [31:0] RfDataOut1,RfDataOut2;//�Ĵ������
	
//Extender

	wire [15:0] extDataIn;//��չ������
	wire [31:0] extDataOut;//��չ�����
	
//DMem

	wire [9:0] dmDataAdr;//���ݵ�ַ
	wire [31:0] dmDataOut;//�������
	wire 		     MemW;//дʹ��
	
//Ctrl
	
	wire [5:0]		op;
	wire [5:0]		funct;
	wire 		jump;						//ָ����ת
	wire 		RegDst;						//rt��rd
	wire [1:0]		Branch;						//��֧
	// wire 		MemR;						//���洢��
	wire 		Mem2R;						//���ݴ洢�����Ĵ�����
	wire 		RegW;						//�Ĵ�����д������
	wire		Alusrc;						//������������ѡ��
	wire [1:0]		ExtOp;						//λ��չ/������չѡ��
	wire [2:0]  Aluctrl;						//Alu����ѡ��

//Alu
	wire [31:0] aluDataIn2;//ALU���� ������չ����Ĵ���
	wire [31:0]	aluDataOut;//ALU���
	wire 		zero;
	
	assign pcSel = ((Branch[0]&&zero)||(Branch[1]&&!zero)) ? 1 : 0;//beq��bnq��֧
	
	
	
//PC��ʵ����	
    PcUnit U_PC(.PC(pcOut),.PcReSet(rst),.PcSel(pcSel),.Clk(clk),.Address(extDataOut));
	// PC PC( .clk(clk), .rst(Reset), PCWr, NPC, PC );
	assign imAdr = pcOut[11:2];
	
//ָ��Ĵ���ʵ����	
	im_4k U_IM(.dout(imOut),.addr(imAdr));
	
//���ָ��
	assign op = imOut[31:26];
	assign funct = imOut[5:0];
	assign rs = imOut[25:21];
	assign rt = imOut[20:16];
	assign rd = (RegDst==0)?imOut[20:16]:imOut[15:11]; 
	assign extDataIn = imOut[15:0];
	
		                
//�Ĵ�����ʵ����
	RF U_RF(.RD1(RfDataOut1),.RD2(RfDataOut2),.clk(clk),.WD(RfDataIn)
			  ,.RFWr(RegW),.A3(rd),.A1(rs),.A2(rt));
//������ʵ����	
	Ctrl U_Ctrl(.jump(jump),.RegDst(RegDst),.Branch(Branch),.Mem2R(Mem2R)
				,.MemW(MemW),.RegW(RegW),.Alusrc(Alusrc),.ExtOp(ExtOp),.Aluctrl(Aluctrl)
				,.OpCode(op),.funct(funct));
				
//��չ��ʵ����	
	EXT U_EXT(.Imm32(extDataOut),.Imm16(extDataIn),.ExtOp(ExtOp));
	
	assign aluDataIn2 = (Alusrc==0)?RfDataOut2:extDataOut;
	
//ALUʵ����	
	alu alu(.C(aluDataOut),.Zero(zero),.A(RfDataOut1),.B(aluDataIn2),.ALUOp(Aluctrl));
	
	
	assign RfDataIn = (Mem2R==1)?dmDataOut:aluDataOut;
	
	
//DMʵ����

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
   
  