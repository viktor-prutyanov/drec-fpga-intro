`include "config.vh"

module imem(
    input  wire         clk,  
    input  wire         rst_n,
       
    input  wire         i_stall,
    input  wire   [7:0] i_addr,
    output wire  [31:0] o_data
);

wire rst = ~rst_n;

`ifdef __ICARUS__

reg  [31:0] mem [0:255];
reg   [7:0] addr;

initial begin
   $readmemh(`IMEM_FILE_TXT, mem);
end

always @(posedge clk or posedge rst) begin
    if (rst)
        addr <= 32'b0;
    else
        if (!i_stall)
            addr <= i_addr;
end

assign o_data = mem[addr];

`else

imem1r32x256 #(
    .INIT_FILE_MIF(`IMEM_FILE_MIF)
)
imem1r32x256(
    .aclr           (rst    ),
    .address        (i_addr ),
    .addressstall_a (i_stall),
    .clock          (clk    ),
    .q              (o_data )
);

`endif

endmodule
