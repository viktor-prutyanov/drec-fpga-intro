module prio_enc #(
    parameter N = 5,
    parameter W = 3
)(
    input wire [N-1:0] dat,
    output reg [W-1:0] idx
);

integer i;
always @(*) begin
    idx = 0;
    for (i = 0; i < N; i = i + 1)
        if (dat[i])
            idx = i[W-1:0];
end

endmodule
