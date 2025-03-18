module fpga_top(
    input  wire CLK,
    input  wire RSTN,

    output wire TXD
);

localparam RATE = 2_000_000;

// RSTN synchronizer
reg rst_n, RSTN_d;

always @(posedge CLK) begin
    rst_n <= RSTN_d;
    RSTN_d <= RSTN;
end

reg [17:0] cnt;

always @(posedge CLK or negedge rst_n) begin
    if (!rst_n)
        cnt <= 0;
    else
        cnt <= cnt + 1'b1;
end

wire [7:0] tx_data;
wire       tx_start = cnt[7:0] == 8'b0;
wire [9:0] rom_addr = cnt[17:8];

uart_tx #(
    .FREQ       (50_000_000),
    .RATE       (      RATE)
) u_uart_tx (
    .clk        (CLK       ),
    .rst_n      (rst_n     ),
    .i_data     (tx_data   ),
    .i_vld      (tx_start  ),
    .o_tx       (TXD       )
);

rom1r_wrap rom_wrap (
	.address        (rom_addr  ),
	.clock          (CLK       ),
	.q              (tx_data   )
);

endmodule