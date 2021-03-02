module clkdiv(input wire clk, output wire clkdiv);

reg [25:0]cnt;
assign clkdiv = cnt[25];

always @(posedge clk)
begin
	cnt <= (cnt === {26{1'b1}}) ? 26'h0 : cnt + 26'h1;
end

endmodule