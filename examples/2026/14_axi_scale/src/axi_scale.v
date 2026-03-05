module axi_scale #(
    parameter M_DATA_WIDTH = 64,
    parameter S_DATA_WIDTH = 32,
    parameter ADDR_WIDTH   = 32
)(
    input  wire clk,
    input  wire rst_n,

    output wire o_irq,

    // AW
    input  wire       [ADDR_WIDTH-1:0]  s_axil_awaddr,
    input  wire                  [2:0]  s_axil_awprot,
    input  wire                         s_axil_awvalid,
    output wire                         s_axil_awready,
    // W
    input  wire     [S_DATA_WIDTH-1:0]  s_axil_wdata,
    input  wire   [S_DATA_WIDTH/8-1:0]  s_axil_wstrb,
    input  wire                         s_axil_wvalid,
    output wire                         s_axil_wready,
    // B
    output wire                  [1:0]  s_axil_bresp,
    output wire                         s_axil_bvalid,
    input  wire                         s_axil_bready,
    // AR
    input  wire       [ADDR_WIDTH-1:0]  s_axil_araddr,
    input  wire                  [2:0]  s_axil_arprot,
    input  wire                         s_axil_arvalid,
    output wire                         s_axil_arready,
    // R
    output wire     [S_DATA_WIDTH-1:0]  s_axil_rdata,
    output wire                         s_axil_rvalid,
    input  wire                         s_axil_rready,

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

localparam NUM_WIDTH = 16;

localparam CNT_WIDTH = 8;
localparam CNT_SHIFT = 6;

assign s_axil_rvalid  = 1'b0;
assign s_axil_arready = 1'b1;

assign m_axi_awid = 1'b0;
assign m_axi_arid = 1'b0;

assign m_axi_bready = 1'b1;

assign m_axi_wstrb = {M_DATA_WIDTH/8{1'b1}};

assign m_axi_awburst = 2'd1; // INCR burst
assign m_axi_awlen   = 8'd7; // 8 beats per burst
assign m_axi_awsize  = 3'd3; // 8 bytes per beat
assign m_axi_awprot  = 3'h0; // Data Secure Unprivileged
assign m_axi_awcache = 4'h0; // Device Non-bufferable

assign m_axi_arburst = 2'd1; // INCR burst
assign m_axi_arlen   = 8'd7; // 8 beats per burst
assign m_axi_arsize  = 3'd3; // 8 bytes per beat
assign m_axi_arprot  = 3'h0; // Data Secure Unprivileged
assign m_axi_arcache = 4'h0; // Device Non-bufferable

wire   [ADDR_WIDTH-1:0] reg_wr_addr;
wire [S_DATA_WIDTH-1:0] reg_wr_data;
wire                    reg_wr_en;

wire start = reg_wr_en && (reg_wr_addr[4:0] == 5'h10) && (reg_wr_data != 0);
wire done;

reg [ADDR_WIDTH-1:0] rd_base;
reg [ADDR_WIDTH-1:0] wr_base;
reg  [CNT_WIDTH-1:0] max_cnt;
reg  [NUM_WIDTH-1:0] scale;

always @(posedge clk) begin
    if (reg_wr_en) begin
        case (reg_wr_addr[4:0])
            5'h0: rd_base <= reg_wr_data;
            5'h4: wr_base <= reg_wr_data;
            5'h8: max_cnt <= reg_wr_data[CNT_WIDTH+CNT_SHIFT-1:CNT_SHIFT] - 1'b1;
            5'hC: scale   <= reg_wr_data[NUM_WIDTH-1:0];
            default: begin end
        endcase
    end
end

axil2reg_wr #(
    .ADDR_WIDTH       (ADDR_WIDTH   ),
    .DATA_WIDTH       (S_DATA_WIDTH )
) u_conv (
    .clk              (clk          ),
    .rst_n            (rst_n        ),

    .s_axil_awaddr    (s_axil_awaddr    ),
    .s_axil_awprot    (s_axil_awprot    ),
    .s_axil_awvalid   (s_axil_awvalid   ),
    .s_axil_awready   (s_axil_awready   ),
    .s_axil_wdata     (s_axil_wdata     ),
    .s_axil_wstrb     (s_axil_wstrb     ),
    .s_axil_wvalid    (s_axil_wvalid    ),
    .s_axil_wready    (s_axil_wready    ),
    .s_axil_bresp     (s_axil_bresp     ),
    .s_axil_bvalid    (s_axil_bvalid    ),
    .s_axil_bready    (s_axil_bready    ),

    .reg_wr_addr      (reg_wr_addr  ),
    .reg_wr_data      (reg_wr_data  ),
    .reg_wr_strb      (             ),
    .reg_wr_en        (reg_wr_en    ),
    .reg_wr_okay      (1'b1         )
);

addr_gen #(
    .ADDR_WIDTH       (ADDR_WIDTH   ),
    .CNT_WIDTH        (CNT_WIDTH    ),
    .CNT_SHIFT        (CNT_SHIFT    )
) u_ag (
    .clk              (clk          ),
    .rst_n            (rst_n        ),

    .i_start          (start        ),
    .o_done           (o_irq        ),

    .i_rd_base        (rd_base      ),
    .i_wr_base        (wr_base      ),
    .i_max_cnt        (max_cnt      ),

    .o_rd_addr_vld    (m_axi_arvalid),
    .o_rd_addr        (m_axi_araddr ),
    .i_rd_addr_rdy    (m_axi_arready),

    .o_wr_addr_vld    (m_axi_awvalid),
    .o_wr_addr        (m_axi_awaddr ),
    .i_wr_addr_rdy    (m_axi_awready),

    .i_wr_resp_vld    (m_axi_bvalid )
);

wire [M_DATA_WIDTH-1:0] data0, data1;
wire                    last;
wire                    valid;
wire                    ready;

generate
genvar i;
for (i = 0; i < M_DATA_WIDTH / NUM_WIDTH; i = i + 1) begin : g_scale
    assign data1[i*NUM_WIDTH +: NUM_WIDTH] = data0[i*NUM_WIDTH +: NUM_WIDTH] * scale;
end
endgenerate

data_buf #(
    .DATAW            (M_DATA_WIDTH ),
    .INFOW            (1            )
) u_buf0 (
    .clk              (clk          ),
    .rst_n            (rst_n        ),

    .i_data           (m_axi_rdata  ),
    .i_info           (m_axi_rlast  ),
    .i_vld            (m_axi_rvalid ),
    .o_rdy            (m_axi_rready ),

    .o_data           (data0        ),
    .o_info           (last         ),
    .o_vld            (valid        ),
    .i_rdy            (ready        )
);

data_buf #(
    .DATAW            (M_DATA_WIDTH ),
    .INFOW            (1            )
) u_buf1 (
    .clk              (clk          ),
    .rst_n            (rst_n        ),

    .i_data           (data1        ),
    .i_info           (last         ),
    .i_vld            (valid        ),
    .o_rdy            (ready        ),

    .o_data           (m_axi_wdata  ),
    .o_info           (m_axi_wlast  ),
    .o_vld            (m_axi_wvalid ),
    .i_rdy            (m_axi_wready )
);

endmodule
