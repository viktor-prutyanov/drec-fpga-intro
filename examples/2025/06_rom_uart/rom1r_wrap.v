module rom1r_wrap(
    input  wire         clock,
    input  wire   [9:0] address,
    output wire   [7:0] q
);

`ifdef __ICARUS__
    reg [7:0] mem [0:1023];
    reg [9:0] addr_d;

    initial $readmemh("data.txt", mem);

    always @(posedge clock)
        addr_d <= address;

    assign q = mem[addr_d];
`else // Quartus/ModelSim
    rom1r u_rom (
    	.address (address),
    	.clock   (clock  ),
    	.q       (q      )
    );
`endif

endmodule