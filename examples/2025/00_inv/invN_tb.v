`timescale 1ns/1ps

module invN_tb;

localparam N = 4;

wire [N-1:0] y;
reg  [N-1:0] x = {N{1'b0}};

always begin
    #1
    if (x == ~y)
        $display("[%0t] x=%b y=%b OK", $realtime, x, y);
    else
        $display("[%0t] x=%b y=%b FAIL", $realtime, x, y);
    #1 x = x + 1;
    if (x == 0) begin
        $display("[%0t] Done", $realtime);
        $finish;
    end
end

invN #(.WIDTH(N)) invN_inst(.i_x(x), .o_y(y));

initial begin
    $dumpvars;
    $display("[%0t] Start", $realtime);
    #100 $finish;
end

endmodule