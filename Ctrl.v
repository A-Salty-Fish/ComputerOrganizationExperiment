

module Ctrl(jump,RegDst,Branch,Mem2R,MemW,RegW,Alusrc,ExtOp,Aluctrl,OpCode,funct);
	
	input [5:0]		OpCode;				//指令操作码字段
	input [5:0]		funct;				//指令功能字段

	output jump;						//指令跳转
	output RegDst;						
	output [1:0] Branch;						//分支
	// output MemR;						//读存储器
	output Mem2R;						//数据存储器到寄存器堆
	output MemW;						//写数据存储器
	output RegW;						//寄存器堆写入数据
	output Alusrc;						//运算器操作数选择
	output [1:0] ExtOp;						//位扩展/符号扩展选择
	output reg[2:0] Aluctrl;						//Alu运算选择
	
	
	assign jump = (OpCode==6'b000010) ;
	assign RegDst = (!OpCode[0] && !(OpCode==6'b001010)) || (OpCode==6'b000000)  ; //slti 001010 slt 000000
	
	assign Branch[0] = (OpCode==6'b000100 ? 1 : 0) ; //beq opcode:000100 funct:000001 !OpCode[5]&&!OpCode[4]&&!OpCode[3]&&OpCode[2]&&!OpCode[1]&&!OpCode[0];
	assign Branch[1] = (OpCode==6'b000101 ? 1 : 0) ; //bne opcode:000101 funct:000001 !OpCode[5]&&!OpCode[4]&&!OpCode[3]&&OpCode[2]&&!OpCode[1]&&OpCode[0];
	
	// assign MemR = (OpCode[0]&&OpCode[1]&&OpCode[5])&&(!OpCode[3]);
	assign Mem2R = (OpCode[0]&&OpCode[1]&&OpCode[5])&&(!OpCode[3]);
	assign MemW = OpCode[1]&&OpCode[0]&&OpCode[3]&&OpCode[5];
	assign RegW = (OpCode[2]&&OpCode[3])||(!OpCode[2]&&!OpCode[3]) || (OpCode==6'b001010) ; // slti 001010
	assign Alusrc = (OpCode[0]||OpCode[1])  &&  (!(OpCode==6'b000101));   //!(!OpCode[5]&&!OpCode[4]&&!OpCode[3]&&OpCode[2]&&!OpCode[1]&&OpCode[0]); //添加bne
	assign ExtOp = {OpCode==6'b001111, !(OpCode[2]&&OpCode[3])}; //修改扩展信号 001111 lui !OpCode[5]&&!OpCode[4]&&OpCode[3]&&OpCode[2]&&OpCode[1]&&OpCode[0]
	
	
	always@(OpCode or funct)
	begin
		Aluctrl[2] = (funct==6'b111111||funct==6'b101010) ;//slti funct:111111 slt funct:101010 
		Aluctrl[1] = ExtOp[0];
		if((OpCode[1]||OpCode[2]) == 0)
			Aluctrl[0] = funct[1]  &&  !(funct==6'b101010);// +slt 
		else
			Aluctrl[0] = !(OpCode[1]||OpCode[0]);
		$display("Control::RegDst:%b Branch:%b Mem2R %b MemW:%b RegW:%b Alusrc: %b",RegDst,Branch,Mem2R,MemW,RegW,Alusrc);
	end
endmodule