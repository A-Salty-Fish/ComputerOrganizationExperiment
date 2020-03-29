module FORWARD_UNIT(rst,EX_RegW,EX_RegRd,ID_RegRs,ID_RegRt,//EX√∞œ’
MEM_RegW,MEM_RegRd,//MEM√∞œ’
FORWARD_Out1,FORWARD_Out2//—°‘Ò∆˜1∫Õ2
);//≈‘¬∑µ•‘™
input rst;
input EX_RegW, MEM_RegW;
input [4:0] EX_RegRd,ID_RegRs,ID_RegRt,MEM_RegRd;
output reg [1:0] FORWARD_Out1,FORWARD_Out2;//—°‘Ò∆˜1∫Õ2

always @(rst or EX_RegW or EX_RegRd or ID_RegRs or ID_RegRt or //EX√∞œ’
MEM_RegW or MEM_RegRd //MEM√∞œ’
)
begin
	if (rst)
	begin
	FORWARD_Out1=2'b00;FORWARD_Out2=2'b00;
	end
	else
	begin
		if (EX_RegW && EX_RegRd!=5'b00000 && EX_RegRd == ID_RegRs)	//EX√∞œ’
		FORWARD_Out1=2'b10;
		else if (MEM_RegW && MEM_RegRd!=5'b00000 && MEM_RegRd==ID_RegRs)	//MEM√∞œ’
		FORWARD_Out1=2'b01;
		else FORWARD_Out1=2'b00;
		if (EX_RegW && EX_RegRd!=5'b00000 && EX_RegRd == ID_RegRt)//EX√∞œ’
		FORWARD_Out2=2'b10;
		else if (MEM_RegW && MEM_RegRd!=5'b00000 && MEM_RegRd==ID_RegRt)//MEM√∞œ’
		FORWARD_Out2=2'b01;
		else FORWARD_Out2=2'b00;
	end
end

endmodule