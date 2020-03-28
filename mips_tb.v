 module mips_tb();
    
   reg clk, rst;
    
   mips U_MIPS(
      .clk(clk), .rst(rst)
   );
    
   initial begin
		// $readmemh( "Test_6_Instr.txt" , U_MIPS.U_IM.imem ) ;
      $readmemh( "Test_Signal.txt" , U_MIPS.U_IM.imem ) ;
	  // $readmemh( "sort.txt" , U_MIPS.U_IM.imem ) ;
      $monitor("PC = 0x%8X, IR = 0x%8X Opcode = %6b funct = %6b rs = %5b rt = %5b rd= %5b shamt = %5b", U_MIPS.U_PC.PC, U_MIPS.imOut ,U_MIPS.op,U_MIPS.funct,U_MIPS.rs,U_MIPS.rt,U_MIPS.rd,U_MIPS.shamt); 
      clk = 1 ;
      rst = 0 ;
      #5 ;
      rst = 1 ;
      #20 ;
      rst = 0 ;
   end
   
   always
	   #(50) clk = ~clk;
   
endmodule
