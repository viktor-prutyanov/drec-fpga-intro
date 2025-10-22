module axil2reg_inc #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter STRB_WIDTH = DATA_WIDTH/8
)(
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
    input  logic                   s_axil_bready    
);

logic [ADDR_WIDTH-1:0]  reg_rd_addr;
logic                   reg_rd_en;
logic [DATA_WIDTH-1:0]  reg_rd_data;
logic                   reg_rd_okay;

logic [ADDR_WIDTH-1:0]  reg_wr_addr;
logic [DATA_WIDTH-1:0]  reg_wr_data;
logic [STRB_WIDTH-1:0]  reg_wr_strb;
logic                   reg_wr_en;
logic                   reg_wr_okay;

axil2reg #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .STRB_WIDTH(STRB_WIDTH)
) axil2reg_inst (.*);

localparam DATA_ADDR = 32'h1000;

logic [DATA_WIDTH-1:0] data;

always_ff @(posedge clk) begin
    if (reg_wr_en) begin
        if (reg_wr_addr == DATA_ADDR) begin
            data <= reg_wr_data;
            reg_wr_okay <= 1'b1;
        end else begin
            reg_wr_okay <= 1'b0;
        end
    end

    if (reg_rd_en) begin
        if (reg_rd_addr == DATA_ADDR) begin
            reg_rd_data <= data + 1'b1;
            reg_rd_okay <= 1'b1;
        end else begin
            reg_rd_okay <= 1'b0;
        end
    end
end
    
endmodule