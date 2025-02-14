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

reg i_start = 1'b0;
reg [7:0] i_data;

uart_tx #(
    .FREQ(1_000_000),
    .RATE(    9_600)
)
u_uart_tx (
    .clk        (clk),
    .rst_n      (rst_n),
    .i_data     (i_data),
    .i_start    (i_start),
    .o_tx       (o_tx)
);

initial begin
    repeat (1000) @(posedge clk);
    i_data  <= 7'h6A;
    i_start <= 1'b1;
    @(posedge clk);
    i_data  <= 7'hXX;
    i_start <= 1'b0;
end

initial begin
    $dumpvars;
    #1000000 $finish;
end

endmodule