module addr_gen #(
    parameter ADDR_WIDTH = 32,
    parameter CNT_WIDTH  = 4,
    parameter CNT_SHIFT  = 3
) (
    input  logic clk,
    input  logic rst_n,

    input  logic i_start,
    output logic o_done,

    input  logic [ADDR_WIDTH-1:0] i_rd_base,
    input  logic [ADDR_WIDTH-1:0] i_wr_base,
    input  logic  [CNT_WIDTH-1:0] i_max_cnt,

    output logic [ADDR_WIDTH-1:0] o_rd_addr,
    output logic                  o_rd_addr_vld,
    input  logic                  i_rd_addr_rdy,

    output logic [ADDR_WIDTH-1:0] o_wr_addr,
    output logic                  o_wr_addr_vld,
    input  logic                  i_wr_addr_rdy,

    input  logic                  i_wr_resp_vld
);

logic [CNT_WIDTH-1:0] rd_addr_cnt, wr_addr_cnt, wr_resp_cnt;

logic rd_addr_fire, wr_addr_fire;
logic rd_last, wr_last, wc_last;

assign rd_addr_fire = o_rd_addr_vld && i_rd_addr_rdy;
assign wr_addr_fire = o_wr_addr_vld && i_wr_addr_rdy;

assign rd_last = rd_addr_cnt == i_max_cnt;
assign wr_last = wr_addr_cnt == i_max_cnt;
assign wc_last = wr_resp_cnt == i_max_cnt;

assign o_rd_addr = i_rd_base + ADDR_WIDTH'({rd_addr_cnt, {CNT_SHIFT{1'b0}}});
assign o_wr_addr = i_wr_base + ADDR_WIDTH'({wr_addr_cnt, {CNT_SHIFT{1'b0}}});

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_wr_addr_vld <= 1'b0;
        o_rd_addr_vld <= 1'b0;
        o_done        <= 1'b0;
    end else begin
        if (i_start) begin
            o_rd_addr_vld <= 1'b1;
            o_wr_addr_vld <= 1'b1;
            o_done        <= 1'b0;
        end else begin
            o_rd_addr_vld <= (rd_addr_fire  && rd_last) ? 1'b0 : o_rd_addr_vld;
            o_wr_addr_vld <= (wr_addr_fire  && wr_last) ? 1'b0 : o_wr_addr_vld;
            o_done        <= (i_wr_resp_vld && wc_last) ? 1'b1 : o_done;
        end
    end
end

always @(posedge clk) begin
    if (i_start) begin
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
