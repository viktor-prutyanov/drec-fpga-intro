module fpga_top(
    input  wire CLK,
    input  wire RSTN,

    input  wire RXD,
    output wire TXD,
    output wire [11:0] LED
);

localparam RATE = 2_000_000;

assign LED[0] = RXD;
assign LED[4] = TXD;
assign {LED[11:5], LED[3:1]}  = ~10'b0;

// RSTN synchronizer
reg rst_n, RSTN_d;

always @(posedge CLK) begin
    rst_n <= RSTN_d;
    RSTN_d <= RSTN;
end

reg [25:0] cnt;

always @(posedge CLK or negedge rst_n) begin
    if (!rst_n)
        cnt <= 0;
    else
        cnt <= cnt + 1'b1;
end

wire [7:0] tx_data  = 8'h30 + cnt[23:20];
wire       tx_start = (cnt[19:0] == 20'b1);

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

endmodule
