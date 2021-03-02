module cnthex( input wire clk, output reg [3:0]hex);

always @(posedge clk)
begin
	hex <= (hex === 4'hf) ? 4'h0 : hex + 4'h1;
end

endmodule