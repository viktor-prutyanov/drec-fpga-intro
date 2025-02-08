// 2-to-4 one-hot decoder
module dec4(
    input  wire [1:0] i_data,
    output reg  [3:0] o_dec
);

// assign o_dec = 4'b1 << i_data;

always @(*) begin
    case (i_data)
        2'd0: o_dec = 4'b0001;
        2'd1: o_dec = 4'b0010;
        2'd2: o_dec = 4'b0100;
        2'd3: o_dec = 4'b1000;
    endcase
end

endmodule