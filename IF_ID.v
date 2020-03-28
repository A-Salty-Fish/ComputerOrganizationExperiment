module IF_ID(pcIn,imIn,clk,pcOut,imOut,rst);
	input clk;
	input rst;
	input [31:0] pcIn;
	input [31:0] imIn;
	
	output reg [31:0] pcOut;
	output reg [31:0] imOut;
	
	always @ (rst or posedge clk)
	begin
		if (rst)
		begin
			pcOut = 0;
			imOut = 0;
		end
		else
		begin
			pcOut = pcIn;
			imOut = imIn;
		end
	end
endmodule