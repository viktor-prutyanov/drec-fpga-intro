module mux #(
    parameter WIDTH = 32
)(
    input  wire [WIDTH-1:0] i0, i1,
    input  wire             sel,
    output reg  [WIDTH-1:0] out
);

always @(*) begin
    case (sel)
        1'b0: out = i0;
        1'b1: out = i1;
    endcase
end

/*
assign out = sel ? i1 : i0; // Signal 'out' must be wire!
*/

/*
always @(*) begin
    if (sel)
        out = i1;
    else
        out = i0;
end
*/

endmodule