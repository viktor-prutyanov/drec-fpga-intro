module ctrl #(
    parameter ADDR_WIDTH = 32,
    parameter CNT_WIDTH  = 4,
    parameter CNT_SHIFT  = 2,
    parameter RD_BASE_ADDR = 32'h0,
    parameter WR_BASE_ADDR = 32'h1000
) (
    input  logic clk,
    input  logic rst_n,

    input  logic i_start,
    output logic o_done,

    output logic                  o_rd_addr_vld,
    output logic [ADDR_WIDTH-1:0] o_rd_addr,
    input  logic                  i_rd_addr_rdy,

    output logic                  o_wr_addr_vld,
    output logic [ADDR_WIDTH-1:0] o_wr_addr,
    input  logic                  i_wr_addr_rdy,

    input  logic                  i_wr_resp_vld
);

logic [CNT_WIDTH-1:0] rd_addr_cnt, wr_addr_cnt, wr_resp_cnt;

logic rd_addr_fire, wr_addr_fire;

assign rd_addr_fire = o_rd_addr_vld && i_rd_addr_rdy;
assign wr_addr_fire = o_wr_addr_vld && i_wr_addr_rdy;

assign o_rd_addr = RD_BASE_ADDR + (ADDR_WIDTH'(rd_addr_cnt) << CNT_SHIFT);
assign o_wr_addr = WR_BASE_ADDR + (ADDR_WIDTH'(wr_addr_cnt) << CNT_SHIFT);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_wr_addr_vld <= 1'b0;
        o_rd_addr_vld <= 1'b0;
        o_done        <= 1'b0;
    end else begin
        o_rd_addr_vld <= i_start ? 1'b1 : ((rd_addr_fire && &rd_addr_cnt) ? 1'b0 : o_rd_addr_vld);
        o_wr_addr_vld <= i_start ? 1'b1 : ((wr_addr_fire && &wr_addr_cnt) ? 1'b0 : o_wr_addr_vld);
        o_done        <= i_start ? 1'b0 : ((i_wr_resp_vld && &wr_resp_cnt) ? 1'b1 : o_done);
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rd_addr_cnt <= '0;
        wr_addr_cnt <= '0;
        wr_resp_cnt <= '0;
    end else begin
        rd_addr_cnt <= rd_addr_fire  ? (rd_addr_cnt + 1'b1) : rd_addr_cnt;
        wr_addr_cnt <= wr_addr_fire  ? (wr_addr_cnt + 1'b1) : wr_addr_cnt;
        wr_resp_cnt <= i_wr_resp_vld ? (wr_resp_cnt + 1'b1) : wr_resp_cnt;
    end
end

endmodule