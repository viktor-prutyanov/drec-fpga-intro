module bin_display #(
    parameter CNT_WIDTH = 14
)(
   input  wire       clk,
   input  wire       rst_n,
   input  wire [3:0] i_data,
   output wire [3:0] o_anodes,
   output reg  [7:0] o_segments
);

reg [CNT_WIDTH-1:0] cnt;
wire          [1:0] pos = cnt[CNT_WIDTH-1:CNT_WIDTH-2];

wire digit = i_data[pos];

always @(posedge clk or negedge rst_n)
   cnt <= !rst_n ? {CNT_WIDTH{1'b0}} : (cnt + 1'b1);

assign o_anodes = ~(4'b1 << pos);

always @(*) begin
   case (digit)
       1'b0: o_segments = 8'b11111100;
       1'b1: o_segments = 8'b01100000;
   endcase
end

endmodule
