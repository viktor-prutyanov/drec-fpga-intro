module mul #(
    parameter N = 18
) (
    input  wire           clk,
    input  wire   [N-1:0] i_a,
    input  wire   [N-1:0] i_b,
    output reg  [2*N-1:0] o_res
);

reg [N-1:0] a, b;

always @(posedge clk) begin
    a     <= i_a;
    b     <= i_b;
    o_res <= a * b;
end

endmodule

