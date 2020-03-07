 module mips_tb();
    
   reg clk, rst;
    
   mips U_MIPS(
      .clk(clk), .rst(rst)
   );
    
   initial begin
      $readmemh( "Test_6_Instr.txt" , U_MIPS.im_4k.imem ) ;
      // $monitor("PC = 0x%8X, IR = 0x%8X", U_MIPS.PcUnit.PC, U_MIPS.instr ); 
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
