module uart_tx #(
    parameter FREQ = 50_000_000,
    parameter RATE = 115_200
) (
    input  wire clk,
    input  wire rst_n,

    input  wire [7:0] i_data,
    input  wire       i_start,
    output reg        o_tx
);

// Enabling Counter
localparam CNT_MAX   = FREQ/RATE-1;
localparam CNT_WIDTH = $clog2(CNT_MAX+1);

reg [CNT_WIDTH-1:0] cnt;
wire en = cnt == CNT_MAX;

// Shifting Register
reg [7:0] data;
reg dout;

// FSM
reg [3:0] state, next_state;

localparam [3:0] IDLE  = {1'b0, 3'd0},
                 START = {1'b0, 3'd1},
                 STOP  = {1'b0, 3'd2},
                 BIT0  = {1'b1, 3'd0},
                 BIT1  = {1'b1, 3'd1},
                 BIT2  = {1'b1, 3'd2},
                 BIT3  = {1'b1, 3'd3},
                 BIT4  = {1'b1, 3'd4},
                 BIT5  = {1'b1, 3'd5},
                 BIT6  = {1'b1, 3'd6},
                 BIT7  = {1'b1, 3'd7};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        cnt <= 0;
    else begin
        if (i_start || en)
            cnt <= 0;
        else
            cnt <= cnt + {{CNT_WIDTH-1{1'b0}}, 1'b1};
    end
end

always @(posedge clk) begin
    if (i_start)
        data <= i_data;
    else if (en) begin
        data <= data >> 1;
        dout <= data[0];
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        state <= IDLE;
    else
        state <= next_state;
end

always @(*) begin
    case (state)
        IDLE:    next_state = i_start ? START : state;
        START:   next_state = en      ? BIT0  : state;
        BIT0:    next_state = en      ? BIT1  : state;
        BIT1:    next_state = en      ? BIT2  : state;
        BIT2:    next_state = en      ? BIT3  : state;
        BIT3:    next_state = en      ? BIT4  : state;
        BIT4:    next_state = en      ? BIT5  : state;
        BIT5:    next_state = en      ? BIT6  : state;
        BIT6:    next_state = en      ? BIT7  : state;
        BIT7:    next_state = en      ? STOP  : state;
        STOP:    next_state = en      ? IDLE  : state;
        default: next_state = state;
    endcase
end

always @(*) begin
    case (state)
        IDLE,
        STOP:    o_tx = 1'b1;
        START:   o_tx = 1'b0;
        default: o_tx = dout;
    endcase
end



endmodule