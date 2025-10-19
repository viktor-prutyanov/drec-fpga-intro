module axil2reg_rd #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
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
    // Register Interface
    output logic [ADDR_WIDTH-1:0]  reg_rd_addr,
    output logic                   reg_rd_en,
    input  logic [DATA_WIDTH-1:0]  reg_rd_data,
    input  logic                   reg_rd_okay
);

localparam AXI_OKAY   = 2'b00;
localparam AXI_SLVERR = 2'b10;

logic idle;
logic okay;
logic [DATA_WIDTH-1:0] data;
logic en_d;

assign s_axil_arready = idle;

assign s_axil_rvalid = !idle;
assign s_axil_rdata = (en_d ? reg_rd_data : data);
assign s_axil_rresp = (en_d ? reg_rd_okay : okay) ? AXI_OKAY : AXI_SLVERR;

assign reg_rd_addr = s_axil_araddr;
assign reg_rd_en = idle && s_axil_arvalid;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        idle <= 1'b1;
        en_d <= 1'b0;
    end else begin
        idle <= idle ? !s_axil_arvalid : s_axil_rready;
        en_d <= reg_rd_en;
    end
end

always_ff @(posedge clk) begin
    if (en_d) begin
        data <= reg_rd_data;
        okay <= reg_rd_okay;
    end
end

endmodule
