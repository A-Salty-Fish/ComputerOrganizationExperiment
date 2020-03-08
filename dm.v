module dm_4k( addr, din, DMWr, clk, dout );
   
   input  [11:2] addr;//地址
   input  [31:0] din;//数据输入端
   input         DMWr;//写使能端
   input         clk;//时钟
   output [31:0] dout;//数据输出端
     
   reg [31:0] dmem[1023:0];//存储器堆
   
   always @(posedge clk) begin
      if (DMWr)
         dmem[addr] <= din;
 // end always
         $display("addr=%8X din=%8X",addr,din);//addr and data to DM
         $display("Mem[00-07]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X",dmem[0],dmem[1],dmem[2],dmem[3],dmem[4],dmem[5],dmem[6],dmem[7]);
       end
	   assign dout = dmem[addr];
endmodule    
