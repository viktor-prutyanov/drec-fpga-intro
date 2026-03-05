module data_buf #(
    parameter DATAW = 64,
    parameter INFOW = 1
) (
    input  logic clk,
    input  logic rst_n,

    input  logic             i_vld,
    output logic             o_rdy,
    input  logic [DATAW-1:0] i_data,
    input  logic [INFOW-1:0] i_info,

    output logic             o_vld,
    input  logic             i_rdy,
    output logic [DATAW-1:0] o_data,
    output logic [INFOW-1:0] o_info
);

logic [1:0] rd_ptr, wr_ptr;

logic [DATAW+INFOW-1:0] mem [2];

assign {o_data, o_info} = mem[rd_ptr[0]];

assign o_rdy = (rd_ptr[0] != wr_ptr[0]) || (rd_ptr[1] == wr_ptr[1]);
assign o_vld = rd_ptr != wr_ptr;

always @(posedge clk) begin
    if (i_vld && o_rdy)
        mem[wr_ptr[0]] <= {i_data, i_info};
end

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        rd_ptr <= 2'b0;
        wr_ptr <= 2'b0;
    end else begin
        if (i_rdy && o_vld)
            rd_ptr <= rd_ptr + 2'b1;
        if (i_vld && o_rdy)
            wr_ptr <= wr_ptr + 2'b1;
    end
end

endmodule
