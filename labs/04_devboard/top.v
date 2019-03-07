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

    output [0:0]LED
);

blink_gen blink_gen(.clk(CLK), .clk2(LED[0]));

endmodule

/*
*   Blinking frequency generator
*/
module blink_gen(
    input clk,

    output clk2
);

reg [25:0]cnt = 0;

assign clk2 = cnt[25];

always @(posedge clk) begin
    cnt <= cnt + 26'b1;
end

endmodule
