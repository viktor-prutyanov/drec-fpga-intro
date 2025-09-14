module dpi_tb;

import "DPI-C" function int hello(input int x);

initial begin
    $display("Hello from Verilog:", hello(0));
end

endmodule