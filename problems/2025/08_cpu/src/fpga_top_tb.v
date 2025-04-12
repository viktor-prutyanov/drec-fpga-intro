`timescale 1ns/1ps

module fpga_top_tb;

reg CLK  = 1'b0;
reg RSTN = 1'b0;

always begin
    #10 CLK <= ~CLK;
end

initial begin
    @(posedge CLK)
    @(posedge CLK)
    RSTN <= 1'b1;
end

fpga_top fpga_top(
    .CLK   (CLK ),
    .RSTN  (RSTN),
    .STCP  (STCP),
    .SHCP  (SHCP),
    .DS    (DS  ),
    .OE    (OE  ) 
);

initial begin
    $dumpvars;
    #20000 $finish;
end

endmodule
