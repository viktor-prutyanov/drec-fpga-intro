module dmem #(
    parameter ADDR_WIDTH = 5,
    parameter DATA_WIDTH = 32
)(
    input  wire clk,

    input  wire                  i_we,
    input  wire            [3:0] i_mask,
    input  wire [ADDR_WIDTH-1:0] i_addr,
    input  wire [DATA_WIDTH-1:0] i_data,
    output wire [DATA_WIDTH-1:0] o_data
);

reg  [31:0] mem[0:31];

always @(posedge clk) begin
    if (i_we) begin
        if (i_mask[0])
            mem[i_addr][7:0]   <= i_data[7:0];
        if (i_mask[1])
            mem[i_addr][15:8]  <= i_data[15:8];
        if (i_mask[2])
            mem[i_addr][23:16] <= i_data[23:16];
        if (i_mask[3])
            mem[i_addr][31:24] <= i_data[31:24];
    end
end

assign o_data = mem[i_addr];

endmodule


