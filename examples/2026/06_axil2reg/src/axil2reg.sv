module axil2reg #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter STRB_WIDTH = DATA_WIDTH/8
) (
    input  logic clk,
    input  logic rst_n,

    // AR
    input  logic [ADDR_WIDTH-1:0]  s_axil_araddr,
    input  logic            [2:0]  s_axil_arprot,
    input  logic                   s_axil_arvalid,
    output logic                   s_axil_arready,
    // R
    output logic [DATA_WIDTH-1:0]  s_axil_rdata,
    output logic            [1:0]  s_axil_rresp,
    output logic                   s_axil_rvalid,
    input  logic                   s_axil_rready,
    // AW
    input  logic [ADDR_WIDTH-1:0]  s_axil_awaddr,
    input  logic            [2:0]  s_axil_awprot,
    input  logic                   s_axil_awvalid,
    output logic                   s_axil_awready,
    // W
    input  logic [DATA_WIDTH-1:0]  s_axil_wdata,
    input  logic [STRB_WIDTH-1:0]  s_axil_wstrb,
    input  logic                   s_axil_wvalid,
    output logic                   s_axil_wready,
    // B
    output logic            [1:0]  s_axil_bresp,
    output logic                   s_axil_bvalid,
    input  logic                   s_axil_bready,
    // Register Read Interface
    output logic [ADDR_WIDTH-1:0]  reg_rd_addr,
    output logic                   reg_rd_en,
    input  logic [DATA_WIDTH-1:0]  reg_rd_data,
    input  logic                   reg_rd_okay,
    // Register Write Interface
    output logic [ADDR_WIDTH-1:0]  reg_wr_addr,
    output logic [DATA_WIDTH-1:0]  reg_wr_data,
    output logic [STRB_WIDTH-1:0]  reg_wr_strb,
    output logic                   reg_wr_en,
    input  logic                   reg_wr_okay
);

axil2reg_rd #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
) rd (.*);

axil2reg_wr #(
    .DATA_WIDTH(DATA_WIDTH),
    .STRB_WIDTH(STRB_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
) wr (.*);

endmodule