`include "ctrl_encode_def.v"
module EXT( Imm16, ExtOp, Imm32 );
    
   input  [15:0] Imm16;
   input  [1:0]  ExtOp;
   output [31:0] Imm32;
   
   reg [31:0] Imm32;
    
   always @(Imm16 or ExtOp) begin
		$display("Extend:Imm16:%8x,ExtOp:%2b,Imm32:%8x",Imm16,ExtOp,Imm32);
      case (ExtOp)
         `EXT_ZERO:    Imm32 = {16'd0, Imm16};
         `EXT_SIGNED:  Imm32 = {{16{Imm16[15]}}, Imm16};
         `EXT_HIGHPOS: Imm32 = {Imm16, 16'd0};
         default: ;
      endcase
   end // end always
    
endmodule
