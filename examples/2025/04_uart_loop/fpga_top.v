module fpga_top(
    input  wire RXD,
    output wire TXD,
    output wire [1:0] LED
);

assign TXD = RXD;
assign LED = {TXD, RXD};

endmodule
