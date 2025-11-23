# Сreate project
create_project fpga ./fpga -part xc7z020clg400-2

# Set target language
set_property target_language Verilog [current_project]

create_bd_design "design_1" -dir fpga

create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0

set_property -dict [list \
  CONFIG.PCW_EN_CLK0_PORT {0} \
  CONFIG.PCW_EN_RST0_PORT {0} \
  CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
  CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
  CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
  CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
  CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} \
  CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {16 Bit} \
  CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J256M16 RE-125} \
  CONFIG.PCW_USE_M_AXI_GP0 {0} \
] [get_bd_cells processing_system7_0]

apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]

validate_bd_design

save_bd_design

make_wrapper -files [get_files fpga/design_1/design_1.bd] -top
add_files -norecurse fpga/design_1/hdl/design_1_wrapper.v

update_compile_order -fileset sources_1
