module fpga_top(
    input  wire CLK,
    input  wire RSTN,

    input  wire RXD,
    output wire TXD,
    output wire [1:0] LED
);

assign LED = {TXD, RXD};

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

wire [7:0] tx_data  = 8'h30 + cnt[25:22];
wire       tx_start = (cnt[21:0] == 22'b1);

uart_tx #(
    .FREQ       (50_000_000),
    .RATE       (   115_200)
) u_uart_tx (
    .clk        (CLK       ),
    .rst_n      (rst_n     ),
    .i_data     (tx_data   ),
    .i_start    (tx_start  ),
    .o_tx       (TXD       )
);

endmodule
