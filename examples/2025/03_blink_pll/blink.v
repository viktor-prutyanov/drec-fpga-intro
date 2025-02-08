module blink #(
    parameter CNT_WIDTH = 26
)(
    input  wire clk,
    input  wire rst_n,

    output wire out
);

reg [CNT_WIDTH-1:0] cnt;

assign out = cnt[CNT_WIDTH-1];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        cnt <= {CNT_WIDTH{1'b0}};
    else
        cnt <= cnt + 1'b1;
end

endmodule
