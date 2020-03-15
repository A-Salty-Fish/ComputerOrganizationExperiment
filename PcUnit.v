
module PcUnit(PC,PcReSet,PcSel,Clk,Address);

	input   PcReSet;
	input [1:0]  PcSel;
	input   Clk;
	input   [31:0] Address;
	
	output reg[31:0] PC;
	
	integer i;
	reg [31:0] temp;
	reg [31:0] temp2;
	always@(posedge Clk or posedge PcReSet)
	begin
		if(PcReSet == 1)
			PC <= 32'h0000_3000;
			
		PC = PC+4;
	  if(PcSel == 2'b01)
				begin
					for(i=0;i<30;i=i+1)
						temp[31-i] = Address[29-i];
					temp[0] = 0;
					temp[1] = 0;
					temp2 = PC;
					PC = PC + temp;
					$display("Branch:Address=%8X temp=%8X curPC=%8X lastPC=%8X",Address,temp,PC,temp2);
				end
		else if (PcSel == 2'b10)
			PC=Address;
	end
endmodule
	
	