`timescale 1ns/1ps

module cnt_tb;

bit clk   = 1'b1;
bit rst_n = 1'b0;

always begin
    #1 clk <= ~clk;
end

initial begin
    @(posedge clk);
    @(posedge clk);
    rst_n <= 1'b1;
end

initial begin
    repeat (100) @(posedge clk);
    $finish;
end

localparam CNT_WIDTH = 5;

logic [CNT_WIDTH-1:0] o_cnt;

cnt #(
    .CNT_WIDTH    (CNT_WIDTH)
) u_cnt (
    .clk          (clk),
    .rst_n        (rst_n),
    .o_cnt        (o_cnt)
);

endmodule