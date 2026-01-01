`timescale 1ns/1ps // Set time units

module inv1_tb; // No inputs/outputs

wire b; // Net ‘y’ (doesn’t store data)
reg a;  // Variable ‘a’ (stores data)

initial a = 1'b0; // Initial assignment before time 0

always begin
    #1 a = ~a; // Wait 1ns, toggle ‘a’ (blocking) and repeat
end

lab00_inv1 lab00_inv1_inst(.i_x(a), .o_y(b));

initial begin
    $dumpvars; // Dump signals to file
    $display("[%t] Start a=%B b=%B", $realtime, a, b); // Print to console
    #10 $display("[%t] Done a=%B b=%B", $realtime, a, b); // Wait 10ns, print
    $finish; // End simulation
end

endmodule
