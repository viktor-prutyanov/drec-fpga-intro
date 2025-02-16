module div3 #(
    parameter N = 8
)(
    input  wire clk,
    input  wire rst_n,

    input  wire [N-1:0] i_x,
    input  wire         i_vld,
    output reg  [N-2:0] o_y,
    output reg          o_vld
);

reg [1:0] state, state_next;

localparam [1:0] IDLE = 0,
                 STEP = 1,
                 DONE = 2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        state <= 0;
    else
        state <= state_next;
end

reg         [N-1:0] x, x_next;      // In buffer
reg [$clog2(N)-1:0] pos, pos_next;  // Position
reg           [1:0] win, win_next;  // Window
reg         [N-2:0] y_next;         // Out buffer

always @(posedge clk) begin
    x   <= x_next;
    pos <= pos_next;
    win <= win_next;
    o_y <= y_next;
end

always @(*) begin
    case (state)
    IDLE: begin
        o_vld      = 1'b0;
        x_next     = i_x;
        pos_next   = N-2;
        win_next   = i_x[N-1:N-2];
        y_next     = 0;
        state_next = i_vld ? STEP : state;
    end
    STEP: begin
        o_vld  = 1'b0;
        x_next = x;

        case (win)
        2'b00: begin
            pos_next   = pos - 2'd2;
            win_next   = {x[pos_next+1], x[pos_next]};
            y_next     = o_y;
            state_next = (pos <= 1) ? DONE : state;
        end
        2'b01: begin
            pos_next   = pos - 2'd1;
            win_next   = {1'b1, x[pos_next]};
            y_next     = o_y;
            state_next = (pos == 0) ? DONE : state;
        end
        2'b10: begin
            pos_next   = pos - 2'd1;
            win_next   = x[pos_next] ? 2'b10 : 2'b01;
            y_next     = o_y + ((pos == 0) ? 0 : (1 << (pos - 2'd1)));
            state_next = (pos == 0) ? DONE : state;
        end
        2'b11: begin
            pos_next   = pos - 2'd2;
            win_next   = {x[pos_next+1], x[pos_next]};
            y_next     = o_y + (1 << pos);
            state_next = (pos <= 1) ? DONE : state;
        end
        endcase
    end
    DONE: begin
        o_vld      = 1'b1;
        x_next     = x;
        pos_next   = pos;
        win_next   = win;
        y_next     = o_y;
        state_next = IDLE;
    end
    endcase
end

endmodule