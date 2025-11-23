open_project fpga/fpga.xpr

launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_runs impl_1 -verbose

write_hw_platform -fixed -include_bit -force -file ./fpga/design_1_wrapper.xsa
