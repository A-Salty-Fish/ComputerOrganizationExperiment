`include "ctrl_encode_def.v"
module alu (A, B, ALUOp, C, Zero);
           
   input  [31:0] A, B;
   input  [4:0]  ALUOp;
   output [31:0] C;
   output        Zero;
   
   reg [31:0] C;
       
   always @( A or B or ALUOp ) begin
      case ( ALUOp )
	     `ALUOp_NOP : C = 0;
		 `ALUOp_OR : C = A | B;
         `ALUOp_SUBU : C = A - B;
		 `ALUOp_ADD : C = A + B;
		 `ALUOp_SUB : C = A + ~B + 1;
		 `ALUOp_SLT : begin
		 if (A[31]==B[31]) C = A < B ? 1 : 0;
		 else if (A[31]==1) C = 1;
		 else C = 0;
		 end
		 `ALUOp_SLL : C = A << B;
		 `ALUOp_SRL : C = A >> B;
		 `ALUOp_SRA : C[31:0] =  ( { {31{A[31]}}, 1'b0 } << (~B[4:0]) ) | ( A >> B[4:0] ) ;
		 `ALUOp_AND : C = A & B;
         default: C = B ;
		// `ALUOp_ADDU: C = A + B;
		// `ALUOp_ADD : C = A + B;
		// `ALUOp_SUBU: C = A - B;
		// `ALUOp_SUB : C = A + ~B + 1;
		// `ALUOp_AND : C = A & B;
		// `ALUOp_OR  : C = A | B;
		// `ALUOp_NOR : C =~(A|B);
		// `ALUOp_XOR : C = (A^B);
		// `ALUOp_SLT : begin
		// if ( (A + (~B) + 1) >> 31 == 1 )
			// C = 1;
		// else
			// C = 0;
		// end
		// `ALUOp_SLTU: begin
		// if ( A < B ) 
			// C = 1;
		// else
			// C = 0;
		// end
		// `ALUOp_SLL : C = A << B;
		// `ALUOp_SRL : C = A >> B;
		// `ALUOp_SRA : C[31:0] =  ( { {31{A}}, 1'b0 } << (~B[4:0]) ) | ( A >> B[4:0] ) ;
		//`ALUOp_EQL
		//`ALUOp_BNE
		//`ALUOp_GT0
		//`ALUOp_GE0
		//`ALUOp_LT0
		//`ALUOp_LE0
         // default:   ;
      endcase
	  $display("ALU: A=%8X B=%8X C=%8X ALUOp=%5b Zero=%b",A,B,C,ALUOp,Zero);
   end // end always;
   
   assign Zero = (A == B) ? 1 : 0;
	
endmodule
    
