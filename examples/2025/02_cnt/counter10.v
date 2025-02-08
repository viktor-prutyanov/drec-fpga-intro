module counter10 (
    input        clk,
    input        rst_n,
    output [3:0] o_cnt
);

reg [3:0] cnt;

assign o_cnt = cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        cnt <= 4'd0;
    else
        if (cnt == 4'd9)
            cnt <= 4'd0;
        else
            cnt <= cnt + 4'd1;
end

endmodule