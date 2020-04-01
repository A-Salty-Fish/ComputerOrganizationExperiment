`include "instruction_def.v"
`include "ctrl_encode_def.v"
module Ctrl(jump,RegDst,Branch,Mem2R,MemW,RegW,Alusrc,ExtOp,Aluctrl,OpCode,funct,shift,nop);
	
	input [5:0]		OpCode;				//指令操作码字段
	input [5:0]		funct;				//指令功能字段
	input nop;
	
	output reg [1:0] jump;						//指令跳转
	output reg RegDst;						
	output reg [1:0] Branch;						//分支

	output reg Mem2R;						//数据存储器到寄存器堆
	output reg MemW;						//写数据存储器
	output reg RegW;						//寄存器堆写入数据
	output reg Alusrc;						//运算器操作数选择
	output reg [1:0] ExtOp;						//位扩展/符号扩展选择
	output reg[4:0] Aluctrl;						//Alu运算选择
	output reg shift;//移位运算
	

	always@(OpCode or funct or nop) 
	begin
		if (nop)//空指令
		begin
			jump=2'b00;Branch=2'b00;
			Mem2R=0;MemW=0;
			RegDst=0;Alusrc=0;shift=0;RegW=0;
			Aluctrl=`ALUOp_ADD;ExtOp=`EXT_ZERO;
		end
		
		else if (OpCode==6'b000000&&funct==6'b000000)  //sll 	shift opcode:000000  
		begin
			jump=2'b00;Branch=2'b00;
			Mem2R=0;MemW=0;
			RegDst=1;Alusrc=1;shift=1;RegW=1;
			Aluctrl=`ALUOp_SLL;ExtOp=`EXT_ZERO;
		end
		
		else if (OpCode==6'b000000&&funct==6'b000010)// srl
		begin
			jump=2'b00;Branch=2'b00;
			Mem2R=0;MemW=0;
			RegDst=1;Alusrc=1;shift=1;RegW=1;
			Aluctrl=`ALUOp_SRL;ExtOp=`EXT_ZERO;
		end
		
		else if (OpCode ==6'b000000&&funct==6'b000011)//sra
		begin
			jump=2'b00;Branch=2'b00;
			Mem2R=0;MemW=0;
			RegDst=1;Alusrc=1;shift=1;RegW=1;
			Aluctrl=`ALUOp_SRA;ExtOp=`EXT_ZERO;
		end
		
		else if (OpCode ==6'b001101)//ori
		begin
			jump=2'b00;Branch=2'b00;
			Mem2R=0;MemW=0;
			RegDst=0;Alusrc=1;shift=0;RegW=1;
			Aluctrl=`ALUOp_OR;ExtOp=`EXT_ZERO;
		end
		
		else if (OpCode==6'b000000&&funct==6'b100100)//and
		begin
			jump=2'b00;Branch=2'b00;
			Mem2R=0;MemW=0;
			RegDst=1;Alusrc=0;shift=0;RegW=1;
			Aluctrl=`ALUOp_AND;ExtOp=`EXT_ZERO;			
		end
		
		else if (OpCode==6'b000000&&funct==6'b100101)//or
		begin
			jump=2'b00;Branch=2'b00;
			Mem2R=0;MemW=0;
			RegDst=1;Alusrc=0;shift=0;RegW=1;
			Aluctrl=`ALUOp_OR;ExtOp=`EXT_ZERO;	
		end
		
		else if (OpCode==6'b000000&&funct==6'b100000)//add
		begin
			jump=2'b00;Branch=2'b00;
			Mem2R=0;MemW=0;
			RegDst=1;Alusrc=0;shift=0;RegW=1;
			Aluctrl=`ALUOp_ADD;ExtOp=`EXT_ZERO;			
		end
		
		else if (OpCode==6'b000000&&funct==6'b100001)//addu
		begin
			jump=2'b00;Branch=2'b00;
			Mem2R=0;MemW=0;
			RegDst=1;Alusrc=0;shift=0;RegW=1;
			Aluctrl=`ALUOp_ADD;ExtOp=`EXT_ZERO;			
		end
		
		else if (OpCode==6'b001000)//addi
		begin
			jump=2'b00;Branch=2'b00;
			Mem2R=0;MemW=0;
			RegDst=0;Alusrc=1;shift=0;RegW=1;
			Aluctrl=`ALUOp_ADD;ExtOp=`EXT_SIGNED;
		end
		
		else if (OpCode==6'b000000&&funct==6'b100010)//sub
		begin
			jump=2'b00;Branch=2'b00;
			Mem2R=0;MemW=0;
			RegDst=1;Alusrc=0;shift=0;RegW=1;
			Aluctrl=`ALUOp_SUBU;ExtOp=`EXT_ZERO;	
		end
		
		else if (OpCode==6'b000000&&funct==6'b100011)//subu
		begin
			jump=2'b00;Branch=2'b00;
			Mem2R=0;MemW=0;
			RegDst=1;Alusrc=0;shift=0;RegW=1;
			Aluctrl=`ALUOp_SUBU;ExtOp=`EXT_ZERO;			
		end
		
		else if (OpCode==6'b001010) //slti
		begin
			jump=2'b00;Branch=2'b00;
			Mem2R=0;MemW=0;
			RegDst=0;Alusrc=1;shift=0;RegW=1;
			Aluctrl=`ALUOp_SLT; ExtOp=`EXT_SIGNED;				
		end
		
		else if (OpCode==6'b000000&&funct==6'b101010) //slt
		begin
			jump=2'b00;Branch=2'b00;
			Mem2R=0;MemW=0;
			RegDst=1;Alusrc=0;shift=0;RegW=1;
			Aluctrl=`ALUOp_SLT; ExtOp=`EXT_SIGNED;	
		end
		
		else if (OpCode==6'b000010)//j
		begin
			jump=2'b01;Branch=2'b00;
			Mem2R=0;MemW=0;
			RegDst=0;RegW=0;Alusrc=0;shift=0;
			ExtOp=`EXT_SIGNED;Aluctrl=5'b00000;
		end
				
		else if (OpCode==6'b000011)//jal
		begin
			jump=2'b10;Branch=2'b00;
			Mem2R=1;MemW=0;
			RegDst=0;Alusrc=0;shift=0;RegW=1;
			Aluctrl=`ALUOp_OR;ExtOp=`EXT_SIGNED;
		end
		
		else if (OpCode==6'b000000&&funct==6'b001000)//jr
		begin
			jump=2'b11;Branch=2'b00;
			Mem2R=0;MemW=0;
			RegDst=0;Alusrc=0;shift=0;RegW=0;
			Aluctrl=6'b111111;ExtOp=`EXT_SIGNED;
		end
		
		else if (OpCode==6'b000100) //beq
		begin
			jump=2'b00;Branch=2'b01;
			Mem2R=0;MemW=0;
			RegDst=0;RegW=0;Alusrc=0;shift=0;
			ExtOp=`EXT_SIGNED;Aluctrl=5'b00000;
		end
		
		else if (OpCode==6'b000101)//bne
		begin
			jump=2'b00;Branch=2'b10;
			Mem2R=0;MemW=0;
			RegDst=0;RegW=0;Alusrc=0;shift=0;
			ExtOp=`EXT_SIGNED;Aluctrl=5'b00000;
		end
		
		else if (OpCode==6'b001111)//lui
		begin
			jump=2'b00;Branch=2'b00;
			Mem2R=0;MemW=0;
			RegDst=0;Alusrc=1;shift=0;RegW=1;
			Aluctrl=6'b111111;ExtOp=`EXT_HIGHPOS;
		end
		
		else if (OpCode==6'b101011)//sw
		begin
			jump=2'b00;Branch=2'b00;
			Mem2R=0;MemW=1;
			RegDst=0;Alusrc=1;shift=0;RegW=0;
			Aluctrl=`ALUOp_ADD;ExtOp=`EXT_SIGNED;
		end
			
		else if (OpCode==6'b100011)//lw
		begin
			jump=2'b00;Branch=2'b00;
			Mem2R=1;MemW=0;
			RegDst=0;Alusrc=1;shift=0;RegW=1;
			Aluctrl=`ALUOp_ADD;ExtOp=`EXT_SIGNED;
		end
		
		else ;
		
		$display("Control::jump:%b RegDst:%b Branch:%3b Mem2R %b MemW:%b RegW:%b Alusrc: %b shift: %b",jump,RegDst,Branch,Mem2R,MemW,RegW,Alusrc,shift);
	end
	
endmodule