`timescale 1ns/1ps

module testbench;

reg clk   = 1'b0;
reg rst_n = 1'b0;

always begin
    #1 clk <= ~clk;
end

localparam N = 8;

reg          i_vld = 1'b0;
reg  [N-1:0] i_x = 0;
wire [N-2:0] o_y;
wire         o_vld;

initial begin
    repeat (3) @(posedge clk);
    rst_n <= 1'b1;
end

always begin
    wait (rst_n == 1'b1);
    @(posedge clk);
    i_vld <= 1'b1;
    @(posedge clk);
    i_vld <= 1'b0;
    wait (o_vld == 1'b1);
    if (o_y != i_x / 3) begin
        $display("[FAIL]");
        $finish;
    end
    i_x <= i_x + 1'b1;
    if (i_x == 2**N-1) begin
        $display("[PASS]");
        $finish;
    end
end

div3 #(N) div3(
    .clk    (clk    ),
    .rst_n  (rst_n  ),
    .i_x    (i_x    ),
    .i_vld  (i_vld  ),
    .o_y    (o_y    ),
    .o_vld  (o_vld  )
);

initial begin
    $dumpvars;
end

endmodule