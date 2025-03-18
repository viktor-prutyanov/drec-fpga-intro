create_clock -period "50.0 MHz" [get_ports CLK]

derive_clock_uncertainty

# UART
set_false_path -from * -to [get_ports TXD]

# Reset
set_false_path -from [get_ports RSTN] -to [all_clocks]

