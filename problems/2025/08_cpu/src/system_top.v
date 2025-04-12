`include "config.vh"

module system_top(
    input  wire clk,
    input  wire rst_n,

    output wire o_stcp,
    output wire o_shcp,
    output wire o_ds,
    output wire o_oe
);

wire [3:0] anodes;
wire [7:0] segments;

wire [15:0] hexd_data;
wire        hexd_wren;

wire [29:0] cpu2mmio_addr;
wire [31:0] cpu2mmio_data;
wire  [3:0] cpu2mmio_mask;
wire        cpu2mmio_wren;
wire [31:0] mmio2cpu_data;

cpu_top cpu_top(
    .clk        (clk            ),
    .rst_n      (rst_n          ),
    .o_mmio_addr(cpu2mmio_addr  ),
    .o_mmio_data(cpu2mmio_data  ),
    .o_mmio_mask(cpu2mmio_mask  ),
    .o_mmio_wren(cpu2mmio_wren  ),
    .i_mmio_data(mmio2cpu_data  )
);

mmio_xbar mmio_xbar(
    .i_mmio_addr(cpu2mmio_addr  ),
    .i_mmio_data(cpu2mmio_data  ),
    .i_mmio_mask(cpu2mmio_mask  ),
    .i_mmio_wren(cpu2mmio_wren  ),
    .o_mmio_data(mmio2cpu_data  ),

    .o_hexd_data(hexd_data      ),
    .o_hexd_wren(hexd_wren      )
);

hex_display hex_display(
    .clk        (clk            ),
    .rst_n      (rst_n          ),
    .i_data     (hexd_data      ),
    .i_we       (hexd_wren      ),
    .o_anodes   (anodes         ),
    .o_segments (segments       )
);

ctrl_74hc595 ctrl_74hc595(
    .clk    (clk                ),
    .rst_n  (rst_n              ),
    .i_data ({segments, anodes} ),
    .o_stcp (o_stcp             ),
    .o_shcp (o_shcp             ),
    .o_ds   (o_ds               ),
    .o_oe   (o_oe               )
);

endmodule
