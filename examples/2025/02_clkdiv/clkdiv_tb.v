`timescale 1ns/1ps

module testbench;

reg clk   = 1'b0;
reg rst_n = 1'b0;

always begin
    #1 clk <= ~clk;
end

initial begin
    repeat (3) @(posedge clk);
    rst_n <= 1'b1;
end

wire clkdiv_out;

clkdiv #(
    .F0(50_000_000),
    .F1(12_500_000)
) clkdiv(.clk(clk), .rst_n(rst_n), .out(clkdiv_out));

initial begin
    $dumpvars;      /* Open for dump of signals */
    $display("Test started...");   /* Write to console */
    #50 $finish;    /* Stop simulation after 50ns */
end

endmodule

