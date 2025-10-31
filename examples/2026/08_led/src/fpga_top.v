module fpga_top(
    input  wire        clk,
    input  wire        rst_n,
    output wire  [3:0] led
);

reg rst_n_d1, rst_n_d2;

always @(posedge clk) begin
    rst_n_d1 <= rst_n;
    rst_n_d2 <= rst_n_d1;
end

localparam CNT_WIDTH = 26;

wire [CNT_WIDTH-1:0] cnt;

assign led = cnt[CNT_WIDTH-1:CNT_WIDTH-4];

cnt #(
    .CNT_WIDTH(CNT_WIDTH)
)
u_cnt (
    .clk    (clk      ),
    .rst_n  (rst_n_d2 ),

    .o_cnt  (cnt      )
);

endmodule