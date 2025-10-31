# Clock
set_property -dict { LOC K17 IOSTANDARD LVCMOS18 } [get_ports clk]

create_clock -period 20.0 [get_ports clk]

# Reset
set_property -dict { LOC M20 IOSTANDARD LVCMOS18 } [get_ports rst_n]

set_false_path -from [get_ports rst_n]

# LEDs
set_property -dict { LOC T12 IOSTANDARD LVCMOS18 } [get_ports {led[3]}]
set_property -dict { LOC U12 IOSTANDARD LVCMOS18 } [get_ports {led[2]}]
set_property -dict { LOC V12 IOSTANDARD LVCMOS18 } [get_ports {led[1]}]
set_property -dict { LOC W13 IOSTANDARD LVCMOS18 } [get_ports {led[0]}]

set_false_path -to [get_ports {led[*]}]