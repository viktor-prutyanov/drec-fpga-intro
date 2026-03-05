module axi_copy #(
    parameter M_DATA_WIDTH = 64,
    parameter S_DATA_WIDTH = 32,
    parameter ADDR_WIDTH   = 32
)(
    input  wire clk,
    input  wire rst_n,

    output wire [ADDR_WIDTH-1:0]        m_axi_awaddr,
    output wire                         m_axi_awid,
    output wire [7:0]                   m_axi_awlen,
    output wire [2:0]                   m_axi_awsize,
    output wire [1:0]                   m_axi_awburst,
    output wire [2:0]                   m_axi_awprot,
    output wire [3:0]                   m_axi_awcache,
    output wire                         m_axi_awvalid,
    input  wire                         m_axi_awready,

    output wire [M_DATA_WIDTH-1:0]      m_axi_wdata,
    output wire [M_DATA_WIDTH/8-1:0]    m_axi_wstrb,
    output wire                         m_axi_wlast,
    output wire                         m_axi_wvalid,
    input  wire                         m_axi_wready,

    input  wire [1:0]                   m_axi_bresp,
    input  wire                         m_axi_bid,
    input  wire                         m_axi_bvalid,
    output wire                         m_axi_bready,

    output wire [ADDR_WIDTH-1:0]        m_axi_araddr,
    output wire                         m_axi_arid,
    output wire [7:0]                   m_axi_arlen,
    output wire [2:0]                   m_axi_arsize,
    output wire [1:0]                   m_axi_arburst,
    output wire [2:0]                   m_axi_arprot,
    output wire [3:0]                   m_axi_arcache,
    output wire                         m_axi_arvalid,
    input  wire                         m_axi_arready,

    input  wire [M_DATA_WIDTH-1:0]      m_axi_rdata,
    input  wire                         m_axi_rid,
    input  wire [1:0]                   m_axi_rresp,
    input  wire                         m_axi_rlast,
    input  wire                         m_axi_rvalid,
    output wire                         m_axi_rready
);

assign m_axi_awid = 1'b0;
assign m_axi_arid = 1'b0;

assign m_axi_bready = 1'b1;

assign m_axi_wstrb = {DATA_WIDTH/8{1'b1}};

assign m_axi_awburst = 2'd1; // INCR burst
assign m_axi_awlen   = 8'd7; // 8 beats per burst
assign m_axi_awsize  = 3'd3; // 8 bytes per beat
assign m_axi_awprot  = 3'h2; // Data Non-Secure Unprivileged
assign m_axi_awcache = 4'h2; // Normal Non-Cacheable Non-bufferable

assign m_axi_arburst = 2'd1; // INCR burst
assign m_axi_arlen   = 8'd7; // 8 beats per burst
assign m_axi_arsize  = 3'd3; // 8 bytes per beat
assign m_axi_arprot  = 3'h2; // Data Non-Secure Unprivileged
assign m_axi_arcache = 4'h2; // Normal Non-Cacheable Non-bufferable

addr_gen #(
    .ADDR_WIDTH       (ADDR_WIDTH),
    .CNT_WIDTH        (4)
    .CNT_SHIFT        (3)
) u_ag (
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

data_buf #(
    .DATAW(DATA_WIDTH),
    .INFOW(1)
) u_buf (
    .clk              (clk),
    .rst_n            (rst_n),

    .i_data           (m_axi_rdata  ),
    .i_info           (m_axi_rlast  ),
    .i_vld            (m_axi_rvalid ),
    .o_rdy            (m_axi_rready ),

    .o_data           (m_axi_wdata  ),
    .o_info           (m_axi_wlast  ),
    .o_vld            (m_axi_wvalid ),
    .i_rdy            (m_axi_wready )
);

endmodule
