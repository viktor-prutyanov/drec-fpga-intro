module inc #(
    parameter DATA_WIDTH = 16,
    parameter INFO_WIDTH = 0
) (
    input  logic clk,
    input  logic rst_n,

    input  logic             i_vld,
    output logic             o_rdy,
    input  logic [DATA_WIDTH-1:0] i_data,
    input  logic [INFO_WIDTH-1:0] i_info,

    output logic             o_vld,
    input  logic             i_rdy,
    output logic [DATA_WIDTH-1:0] o_data,
    output logic [INFO_WIDTH-1:0] o_info
);

logic x_vld, x_rdy;
logic [DATA_WIDTH-1:0] x_data;
logic [DATA_WIDTH-1:0] x_inc;
logic [INFO_WIDTH-1:0] info;

assign x_inc = x_data + 1'b1;

peb #(
    .WIDTH(DATA_WIDTH+INFO_WIDTH)
) b0 (
    .clk       (clk    ),
    .rst_n     (rst_n  ),

    .i_vld     (i_vld  ),
    .o_rdy     (o_rdy  ),
    .i_data    ({i_info, i_data}),

    .o_vld     (x_vld  ),
    .i_rdy     (x_rdy  ),
    .o_data    ({info, x_data})
);

peb #(
    .WIDTH(DATA_WIDTH+INFO_WIDTH)
) b1 (
    .clk       (clk    ),
    .rst_n     (rst_n  ),

    .i_vld     (x_vld  ),
    .o_rdy     (x_rdy  ),
    .i_data    ({info, x_inc}),

    .o_vld     (o_vld  ),
    .i_rdy     (i_rdy  ),
    .o_data    ({o_info, o_data})
);

endmodule