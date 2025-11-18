# Сreate project
create_project fpga ./fpga -part xc7z020clg400-2

# Set target language
set_property target_language Verilog [current_project]

# Add HDL sources
add_files -fileset sources_1 ./src/cnt.sv
add_files -fileset sources_1 ./src/fpga_top.v

# Add testbench
add_files -fileset sim_1 ./src/cnt_tb.sv

# Add constraints
add_files -fileset constrs_1 ./xdc/fpga.xdc

# Don't use in simulation
set_property used_in_simulation false [get_files ./src/fpga_top.v]

# Update compile order
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# Set top module for synthesis
set_property top fpga_top [get_filesets sources_1]

# Set top module for simulation
set_property top cnt_tb [get_filesets sim_1]
