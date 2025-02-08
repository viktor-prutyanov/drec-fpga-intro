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

ctrl_74hc595 ctrl(
    .clk    (clk    ),
    .rst_n  (rst_n  ),
    .i_data (12'h5A1),
    .o_oe   (oe     ),
    .o_stcp (stcp   ),
    .o_shcp (shcp   ),
    .o_ds   (ds     )
);

initial begin
    $dumpvars;
    $display("Test started...");
    #1000 $finish;
end

endmodule