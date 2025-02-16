module mul #(
    parameter N = 32
) (
    input  wire clk,
    input  wire rst_n,
 
    input  wire [N-1:0] i_a,
    input  wire [N-1:0] i_b,
    input  wire         i_vld,
    output reg  [N-1:0] o_res,
    output reg          o_vld
);

reg [1:0] state, state_next;

localparam [1:0] IDLE = 0,
                 STEP = 1,
                 DONE = 2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        state <= IDLE;
    else
        state <= state_next;
end

reg [N-1:0] a, b;
reg sel;
wire empty = (a == {N{1'b0}}) || (b == {N{1'b0}});

always @(posedge clk) begin
    a     <= sel ? i_a       : (a >> 1);
    b     <= sel ? i_b       : (b << 1);
    o_res <= sel ? {N{1'b0}} : (o_res + (a[0] ? b : {N{1'b0}}));
end

always @(*) begin
    case (state)
    IDLE: begin
        sel        = 1'b1;
        o_vld      = 1'b0;
        state_next = i_vld ? STEP : state;
    end
    STEP: begin
        sel        = 1'b0;
        o_vld      = 1'b0;
        state_next = empty ? DONE : state;
    end
    DONE: begin
        sel        = 1'b0;
        o_vld      = 1'b1;
        state_next = IDLE;
    end
    endcase
end

endmodule

