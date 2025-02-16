module fsm_cnt(
    input  wire clk,
    input  wire rst_n,
    input  wire en,
    output wire out
);

reg [1:0] state, state_next;

localparam [1:0] S0 = 0, S1 = 1, S2 = 2, S3 = 3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        state <= S0;
    else
        state <= state_next;
end

always @(*) begin // Next state logic
    case (state)
    S0: state_next = en ? S1 : state;
    S1: state_next = en ? S2 : state;
    S2: state_next = en ? S3 : state;
    S3: state_next = en ? S0 : state;
    endcase
end

assign out = (state == S3); // Output logic

endmodule