create_clock -period "50.0 MHz" [get_ports clk]

derive_clock_uncertainty

set_false_path -from rst_n -to [all_clocks]