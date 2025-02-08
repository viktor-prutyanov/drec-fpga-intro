// 4-to-2 MSB priority encoder
module prio_enc4(
    input  wire [3:0] i_data,
    output  reg [1:0] o_enc,
    output wire       o_vld
);

always @(*) begin
    casez (i_data)
        4'b1???: o_enc = 2'd3;
        4'b01??: o_enc = 2'd2;
        4'b001?: o_enc = 2'd1;
        4'b0001: o_enc = 2'd0;
        default: o_enc = 2'dX;
    endcase
end

assign o_vld = |i_data;

endmodule