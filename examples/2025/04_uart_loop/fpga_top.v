module fpga_top(
    input  wire RXD,
    output wire TXD,
    output wire [11:0] LED
);

assign TXD = RXD;

assign LED[0] = RXD;
assign LED[4] = TXD;
assign {LED[11:5], LED[3:1]}  = ~10'b0;

endmodule
