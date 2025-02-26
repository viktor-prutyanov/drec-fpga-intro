// Flip-flop with data, reset and enable
module fdre( 
    input  wire clk,
    input  wire rst_n, 
    input  wire d,
    input  wire en,
    output reg  q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= 0;
    end else if (en) begin
        q <= d;
    end
end

endmodule