`include "config.vh"

module fpga_top(
    input  wire CLK,
    input  wire RSTN,

    output wire STCP,
    output wire SHCP,
    output wire DS,
    output wire OE
);

reg rst_n, RSTN_d;

always @(posedge CLK) begin
    rst_n  <= RSTN_d;
	RSTN_d <= RSTN;
end

system_top system_top(
    .clk    (CLK    ),
    .rst_n  (rst_n  ),
    .o_stcp (STCP   ),
    .o_shcp (SHCP   ),
    .o_ds   (DS     ),
    .o_oe   (OE     )
);

endmodule
