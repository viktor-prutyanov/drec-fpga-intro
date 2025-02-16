`timescale 1ns/1ps

module tb;

reg clk   = 1'b0;
reg rst_n = 1'b0;

always begin
    #1 clk <= ~clk;
end

localparam N = 16;

reg          i_vld = 1'b0;
reg  [N-1:0] i_a, i_b, res;
wire [N-1:0] o_res;
wire         o_vld;

initial begin
    repeat (3) @(posedge clk);
    rst_n <= 1'b1;
end

always begin
    wait (rst_n == 1'b1);
    @(posedge clk);
    i_vld <= 1'b1;
    i_a   <= $urandom_range(0, 2**(N/2)-1);
    i_b   <= $urandom_range(0, 2**(N/2)-1);
    @(posedge clk);
    res   <= i_a * i_b;
    i_vld <= 1'b0;
    i_a   <= {N{1'bX}};
    i_b   <= {N{1'bX}};
    wait (o_vld == 1'b1);
    if (res != o_res) begin
        $display("[FAIL]");
        $finish;
    end
end

mul #(N) mul(
    .clk      (clk  ),
    .rst_n    (rst_n),
    .i_a      (i_a  ),
    .i_b      (i_b  ),
    .i_vld    (i_vld),
    .o_res    (o_res),
    .o_vld    (o_vld)
);

initial begin
    $dumpvars;
    #1000 $display("[PASS]");
    $finish;
end

endmodule