module fpga_top(
    input  wire        CLK,   // CLOCK
    input  wire        RSTN,  // BUTTON RST (NEGATIVE)
    output wire [11:0] LED    // LEDs (NEGATIVE)
);

reg rst_n, RSTN_d;

assign LED[11:1] = {11{1'b1}};

always @(posedge CLK) begin
    rst_n <= RSTN_d;
    RSTN_d <= RSTN;
end

blink blink(
    .clk    (CLK      ),
    .rst_n  (rst_n    ),
    .out    (LED[0]   )
);

endmodule
