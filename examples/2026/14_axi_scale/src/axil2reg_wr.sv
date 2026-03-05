module axil2reg_wr #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter STRB_WIDTH = DATA_WIDTH/8
) (
    input  logic clk,
    input  logic rst_n,

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
    // Register Interface
    output logic [ADDR_WIDTH-1:0]  reg_wr_addr,
    output logic [DATA_WIDTH-1:0]  reg_wr_data,
    output logic [STRB_WIDTH-1:0]  reg_wr_strb,
    output logic                   reg_wr_en,
    input  logic                   reg_wr_okay
);

localparam AXI_OKAY   = 2'b00;
localparam AXI_SLVERR = 2'b10;

logic idle;
logic okay;
logic [DATA_WIDTH-1:0] data;
logic en_d;

assign s_axil_awready = idle && s_axil_wvalid;
assign s_axil_wready  = idle && s_axil_awvalid;

assign s_axil_bresp = (en_d ? reg_wr_okay : okay) ? AXI_OKAY : AXI_SLVERR;
assign s_axil_bvalid = !idle;

assign reg_wr_addr = s_axil_awaddr;
assign reg_wr_data = s_axil_wdata;
assign reg_wr_strb = s_axil_wstrb;
assign reg_wr_en = idle && s_axil_awvalid && s_axil_wvalid;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        idle <= 1'b1;
        en_d <= 1'b0;
    end else begin
        idle <= idle ? !(s_axil_awvalid && s_axil_wvalid) : s_axil_bready;
        en_d <= reg_wr_en;
    end
end

always_ff @(posedge clk) begin
    if (en_d) begin
        okay <= reg_wr_okay;
    end
end

endmodule
