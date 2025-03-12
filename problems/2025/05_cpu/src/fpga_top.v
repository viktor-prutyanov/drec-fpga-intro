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

wire  [3:0] anodes;
wire  [7:0] segments;

system_top system_top (
    .clk         (CLK       ),
    .rst_n       (rst_n     ),
    .anodes      (anodes    ),
    .segments    (segments  )
);

ctrl_74hc595 ctrl_74hc595 (
    .clk        (CLK                ),
    .rst_n      (rst_n              ),
    .i_data     ({segments, anodes} ),
    .o_stcp     (STCP               ),
    .o_shcp     (SHCP               ),
    .o_ds       (DS                 ),
    .o_oe       (OE                 )
);

endmodule
