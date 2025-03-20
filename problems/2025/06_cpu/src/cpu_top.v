`include "config.vh"

module cpu_top(
    input  wire clk,
    input  wire rst_n,

    output wire [29:0] o_mmio_addr,
    output wire [31:0] o_mmio_data,
    output wire  [3:0] o_mmio_mask,
    output wire        o_mmio_wren,
    input  wire [31:0] i_mmio_data
);

wire [29:0] core2imem_addr;
wire [31:0] imem2core_data;

wire [29:0] core2xbar_addr;
wire [31:0] core2xbar_data;
wire        core2xbar_wren;
wire  [3:0] core2xbar_mask;
wire [31:0] xbar2core_data;

wire [29:0] xbar2dmem_addr;
wire [31:0] xbar2dmem_data;
wire        xbar2dmem_wren;
wire  [3:0] xbar2dmem_mask;
wire [31:0] dmem2xbar_data;


imem imem(
    .clk        (clk            ),
    .rst_n      (rst_n          ),
    .i_addr     (core2imem_addr ),
    .o_data     (imem2core_data )
);

dmem dmem(
    .clk           (clk             ),
    .i_addr        (xbar2dmem_addr  ),
    .i_data        (xbar2dmem_data  ),
    .i_we          (xbar2dmem_wren  ),
    .i_mask        (xbar2dmem_mask  ),
    .o_data        (dmem2xbar_data  )
);

mem_xbar #(
    .DATA_START    (`XBAR_DATA_START),
    .DATA_LIMIT    (`XBAR_DATA_LIMIT),
    .MMIO_START    (`XBAR_MMIO_START),
    .MMIO_LIMIT    (`XBAR_MMIO_LIMIT)
)
mem_xbar(
    .clk           (clk             ),
    .i_addr        (core2xbar_addr  ),
    .i_data        (core2xbar_data  ),
    .i_wren        (core2xbar_wren  ),
    .i_mask        (core2xbar_mask  ),
    .o_data        (xbar2core_data  ),
    .o_dmem_addr   (xbar2dmem_addr  ),
    .o_dmem_data   (xbar2dmem_data  ),
    .o_dmem_mask   (xbar2dmem_mask  ),
    .o_dmem_wren   (xbar2dmem_wren  ),
    .i_dmem_data   (dmem2xbar_data  ),
    .o_mmio_addr   (o_mmio_addr     ),
    .o_mmio_data   (o_mmio_data     ),
    .o_mmio_wren   (o_mmio_wren     ),
    .o_mmio_mask   (o_mmio_mask     ),
    .i_mmio_data   (i_mmio_data     )
);

core core(
    .clk           (clk             ),
    .rst_n         (rst_n           ),
    .i_instr_data  (imem2core_data  ),
    .o_instr_addr  (core2imem_addr  ),
    .o_mem_addr    (core2xbar_addr  ),
    .o_mem_data    (core2xbar_data  ),
    .o_mem_we      (core2xbar_wren  ),
    .o_mem_mask    (core2xbar_mask  ),
    .i_mem_data    (xbar2core_data  )
);

endmodule

