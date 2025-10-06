module sqr #(
    parameter WIDTH = 16
) (
    input  logic clk,
    input  logic rst_n,

    input  logic             s_axis_tvalid,
    output logic             s_axis_tready,
    input  logic [WIDTH-1:0] s_axis_tdata,

    output logic               m_axis_tvalid,
    input  logic               m_axis_tready,
    output logic [2*WIDTH-1:0] m_axis_tdata    
);

logic               x_vld;
logic               x_rdy;
logic   [WIDTH-1:0] x_data;
logic [2*WIDTH-1:0] x2_data;

assign x2_data = x_data * x_data;

peb #(
    .WIDTH     (WIDTH)
) b0 (
    .clk       (clk             ),
    .rst_n     (rst_n           ),

    .i_vld     (s_axis_tvalid   ),
    .o_rdy     (s_axis_tready   ),
    .i_data    (s_axis_tdata    ),

    .o_vld     (x_vld           ),
    .i_rdy     (x_rdy           ),
    .o_data    (x_data          )
);

peb #(
    .WIDTH     (2*WIDTH)
) b1 (
    .clk       (clk             ),
    .rst_n     (rst_n           ),

    .i_vld     (x_vld           ),
    .o_rdy     (x_rdy           ),
    .i_data    (x2_data         ),

    .o_vld     (m_axis_tvalid   ),
    .i_rdy     (m_axis_tready   ),
    .o_data    (m_axis_tdata    )
);

endmodule