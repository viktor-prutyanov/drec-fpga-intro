module fpga_top(
    input  wire        CLK,   // CLOCK
    input  wire        RSTN,  // BUTTON RST (NEGATIVE)
    output wire [11:0] LED    // LEDs (NEGATIVE)
);

reg rst_n, RSTN_d;

wire clk_1MHz;

assign LED[11:1] = {11{1'b1}};

always @(posedge clk_1MHz) begin
    rst_n <= RSTN_d;
    RSTN_d <= RSTN;
end

pll pll(
    .inclk0	 (CLK	   ),
    .c0      (clk_1MHz )
);

blink #(
    .CNT_WIDTH  (20)
)
blink(
    .clk     (clk_1MHz ),
    .rst_n   (rst_n    ),
    .out     (LED[0]   )
);

endmodule
