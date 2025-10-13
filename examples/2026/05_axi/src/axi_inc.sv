module axi_inc #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 16
) (
    input  logic clk,
    input  logic rst_n,

    input  logic i_start,
    output logic o_done,

    output logic [ADDR_WIDTH-1:0]        m_axi_awaddr,
    output logic                         m_axi_awid,
    output logic [7:0]                   m_axi_awlen,
    output logic [2:0]                   m_axi_awsize,
    output logic [1:0]                   m_axi_awburst,
    output logic [2:0]                   m_axi_awprot,
    output logic                         m_axi_awvalid,
    input  logic                         m_axi_awready,

    output logic [DATA_WIDTH-1:0]        m_axi_wdata,
    output logic                         m_axi_wlast,
    output logic                         m_axi_wvalid,
    input  logic                         m_axi_wready,

    input  logic [1:0]                   m_axi_bresp,
    input  logic                         m_axi_bid,
    input  logic                         m_axi_bvalid,
    output logic                         m_axi_bready,

    output logic [ADDR_WIDTH-1:0]        m_axi_araddr,
    output logic                         m_axi_arid,
    output logic [7:0]                   m_axi_arlen,
    output logic [2:0]                   m_axi_arsize,
    output logic [1:0]                   m_axi_arburst,
    output logic [2:0]                   m_axi_arprot,
    output logic                         m_axi_arvalid,
    input  logic                         m_axi_arready,

    input  logic [DATA_WIDTH-1:0]        m_axi_rdata,
    input  logic                         m_axi_rid,
    input  logic [1:0]                   m_axi_rresp,
    input  logic                         m_axi_rlast,
    input  logic                         m_axi_rvalid,
    output logic                         m_axi_rready
);

assign m_axi_awid = 1'b0;
assign m_axi_arid = 1'b0;

assign m_axi_bready = 1'b1;

assign m_axi_awburst = 2'd1; // INCR burst
assign m_axi_awlen   = 8'd3; // 4 beats per burst
assign m_axi_awsize  = 3'd1; // 16 bytes per beat
assign m_axi_awprot  = 3'h0; // Data, Secure, Unprivileged

assign m_axi_arburst = 2'd1; // INCR burst
assign m_axi_arlen   = 8'd3; // 4 beats per burst
assign m_axi_arsize  = 3'd1; // 16 bytes per beat
assign m_axi_arprot  = 3'h0; // Data, Secure, Unprivileged

inc #(
    .DATA_WIDTH(DATA_WIDTH),
    .INFO_WIDTH(1)
) u_inc (
    .clk       (clk),
    .rst_n     (rst_n),

    .i_vld     (m_axi_rvalid),
    .o_rdy     (m_axi_rready),
    .i_data    (m_axi_rdata ),
    .i_info    (m_axi_rlast ),

    .o_vld     (m_axi_wvalid),
    .i_rdy     (m_axi_wready),
    .o_data    (m_axi_wdata ),
    .o_info    (m_axi_wlast )
);

ctrl #(
    .ADDR_WIDTH       (32),
    .CNT_WIDTH        (4),
    .CNT_SHIFT        (2),
    .WR_BASE_ADDR     (32'h1000),
    .RD_BASE_ADDR     (32'h0000)
) u_ctrl (
    .clk              (clk),
    .rst_n            (rst_n),

    .i_start          (i_start),
    .o_done           (o_done),

    .o_rd_addr_vld    (m_axi_arvalid),
    .o_rd_addr        (m_axi_araddr ),
    .i_rd_addr_rdy    (m_axi_arready),

    .o_wr_addr_vld    (m_axi_awvalid),
    .o_wr_addr        (m_axi_awaddr ),
    .i_wr_addr_rdy    (m_axi_awready),

    .i_wr_resp_vld    (m_axi_bvalid )
);

endmodule