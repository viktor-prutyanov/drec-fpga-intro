module sync(
    input  wire clk,
    input  wire rst_n,

    input  wire i_d,
    output reg  o_d
);

reg [1:0] d;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_d <= 1'b0;
        d   <= 2'b0;
    end else begin
        o_d  <= d[1];
        d[1] <= d[0];
        d[0] <= i_d;
    end
end

endmodule
