module im_4k( addr, dout );
    
    input [9:0] addr;
    input [31:0] dout;
    
    reg [31:0] imem[63:0];
    
    assign dout = imem[addr];
    
endmodule    
