`define BEHAVIORAL

`ifdef BEHAVIORAL
module invN #(
    parameter WIDTH = 8
)(
    input  wire [WIDTH-1:0] i_x,
    output wire [WIDTH-1:0] o_y
);

assign o_y = ~i_x;

endmodule
`else
module invN #(
    parameter WIDTH = 8
)(
    input  wire [WIDTH-1:0] i_x,
    output wire [WIDTH-1:0] o_y
);

generate
genvar i;
for (i = 0; i < WIDTH; i = i + 1) begin : gen_inv1s
	inv1 inv1_inst(.i_x(i_x[i]), .o_y(o_y[i]));
end
endgenerate

endmodule
`endif