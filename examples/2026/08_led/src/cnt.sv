module cnt #(
    parameter CNT_WIDTH = 0
) (
    input   logic        clk,
    input   logic        rst_n,

    output  logic [CNT_WIDTH-1:0] o_cnt
);

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        o_cnt <= '0;
    else
        o_cnt <= o_cnt + 1'b1;
end

endmodule