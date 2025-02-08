`timescale 1ns/1ps

module testbench;

reg clk   = 1'b0;
reg rst_n = 1'b0;

always begin
    #1 clk = ~clk; /* Toggle clock every 1ns */
end

initial begin
    #5 rst_n = 1'b1; /* Reset after 5ns */
end

wire [3:0] o_cnt;

counter10 counter(.clk(clk), .rst_n(rst_n), .o_cnt(o_cnt));

initial begin
    $dumpvars;      /* Open for dump of signals */
    $display("Test started...");   /* Write to console */
    #50 $finish;    /* Stop simulation after 50ns */
end

endmodule

