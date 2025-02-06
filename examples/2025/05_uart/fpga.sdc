create_clock -period "50.0 MHz" [get_ports CLK]

derive_clock_uncertainty

set_false_path -from * -to TXD
set_false_path -from KEY1 -to [all_clocks] 