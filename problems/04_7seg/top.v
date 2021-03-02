/*
*   Introduction to FPGA and Verilog
*
*   Viktor Prutyanov, 2019
*
*   LED blinking
*/

/*
*   Top-level module
*/
module top(
    input CLK,
	 output DS_EN1, DS_EN2, DS_EN3, DS_EN4,
	 output DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G
);

assign {DS_EN1, DS_EN2, DS_EN3, DS_EN4} = 4'b0111;

wire clkdiv;
wire [3:0]hex;
wire [6:0]seg;

clkdiv Clkdiv1( .clk(CLK), .clkdiv(clkdiv));
cnthex Cnthex1( .clk(clkdiv), .hex(hex));
hex2seg Hex2seg( .hex(hex), .seg(seg));

assign {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = seg;


endmodule
