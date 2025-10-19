module peb #(
    parameter WIDTH = 0
) (
    input  logic clk,
    input  logic rst_n,

    input  logic             i_vld,
    output logic             o_rdy,
    input  logic [WIDTH-1:0] i_data,

    output logic             o_vld,
    input  logic             i_rdy,
    output logic [WIDTH-1:0] o_data
);

logic full;

assign o_vld = full;
assign o_rdy = !full || i_rdy;

always @(posedge clk, negedge rst_n) begin
    if (!rst_n)
        full <= 1'b0;
    else begin
        if (i_vld)
            full <= 1'b1;
        else if (i_rdy)
            full <= 1'b0;
    end
end

always @(posedge clk) begin
    if (!full || i_rdy)
        o_data <= i_data;
end

endmodule