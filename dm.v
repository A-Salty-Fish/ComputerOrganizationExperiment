module dm_4k( addr, din, DMWr, clk, dout );
   
   input  [11:2] addr;//��ַ
   input  [31:0] din;//���������
   input         DMWr;//дʹ�ܶ�
   input         clk;//ʱ��
   output [31:0] dout;//���������
     
   reg [31:0] dmem[1023:0];//�洢����
   
   always @(posedge clk) begin
      if (DMWr)
         dmem[addr] <= din;
 // end always
         $display("addr=%8X din=%8X",addr,din);//addr and data to DM
         $display("Mem[00-07]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X",dmem[0],dmem[1],dmem[2],dmem[3],dmem[4],dmem[5],dmem[6],dmem[7]);
       end
	   assign dout = dmem[addr];
endmodule    
