module MEM_WB(rst,clk,DmAddr,DmOut,Rd,RegW,Mem2R,
RegDmAddr,RegDmOut,RegRd,RegRegW,RegMem2R
);
	input rst;input clk;input [9:0] DmAddr;input [31:0] DmOut;input [4:0] Rd; input RegW; input Mem2R;
	
	output reg [9:0] RegDmAddr; output reg [31:0] RegDmOut; output reg [4:0] RegRd; output reg RegRegW;output reg RegMem2R;
	
	always @(rst or posedge clk)
	begin
		if (rst)
		begin
			RegDmAddr=0;RegDmOut=0;RegRd=0;RegRegW=0;RegMem2R=0;
		end
		else
		begin
			RegDmAddr=DmAddr;RegDmOut=DmOut;RegRd=Rd;RegRegW=RegW;RegMem2R=Mem2R;
		end
	end

endmodule