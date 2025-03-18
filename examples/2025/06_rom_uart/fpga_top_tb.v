`timescale 1ns/1ps

module tb;

reg clk   = 1'b0;
reg rst_n = 1'b0;

always begin
    #10 clk <= ~clk;
end

initial begin
    repeat (5) @(posedge clk);
    rst_n <= 1'b1;
end

wire txd;

fpga_top u_fpga_top (
    .CLK    (clk    ),
    .RSTN   (rst_n  ),
    .TXD    (txd    )
);

initial begin
    $dumpvars;
    #2_000_000 $finish;
end

endmodule
