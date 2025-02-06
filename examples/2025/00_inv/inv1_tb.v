`timescale 1ns/1ps // Set time units

module inv1_tb; // No inputs/outputs

wire y;       // Net ‘y’ (doesn’t store data)
reg x = 1'b0; // Variable ‘x’ (stores data)

always begin
    #1 x = ~x; // Wait 1ns, toggle ‘x’ and repeat
end

lab00_inv1 lab00_inv1_inst(.i_x(x), .o_y(y));

initial begin
    $dumpvars; // Dump signals to file
    $display("[%t] Start x=%B y=%B", $realtime, x, y); // Print to console
    #10 $display("[%t] Done", $realtime); // Wait 10ns, print
    $finish; // End simulation
end

endmodule
