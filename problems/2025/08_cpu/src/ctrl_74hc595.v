module ctrl_74hc595(
    input wire clk,
    input wire rst_n,

    input wire [11:0] i_data,

    output wire o_stcp,
    output wire o_shcp,
    output wire o_ds,
    output wire o_oe
);

reg   [4:0] cnt;
wire  [3:0] pos = cnt[4:1];
wire [15:0] data = {4'b0, i_data};

assign o_stcp = (pos == 4'd12) && cnt[0];
assign o_shcp = (pos <= 4'd11) && cnt[0];
assign o_ds = data[pos];
assign o_oe = ~rst_n;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        cnt <= 5'd0;
    else
        cnt <= cnt + 1'b1;
end


endmodule
