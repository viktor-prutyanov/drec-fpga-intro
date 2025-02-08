module reg_file(
    input  wire        clk,

    input  wire  [3:0] i_rd_addr,
    output wire  [7:0] o_rd_data,

    input  wire  [3:0] i_wr_addr,
    input  wire  [7:0] i_wr_data,
    input  wire        i_wr_en
);

reg [7:0] r[15:0]; // Unpacked array

assign o_rd_data = r[i_rd_addr];

always @(posedge clk) begin
    if (i_wr_en) begin
        r[i_wr_addr] <= i_wr_data;
    end
end

endmodule