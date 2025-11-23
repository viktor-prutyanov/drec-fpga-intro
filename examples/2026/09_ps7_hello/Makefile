clean:
	rm -rf transcript work obj_dir *.log *.jou *.vcd .Xil fpga

project:
	vivado -mode batch -source project.tcl

impl:
	vivado -mode batch -source impl.tcl

vitis:
	vitis -s build.py

bootgen:
	bootgen -image input.bif -arch zynq -o BOOT.bin -w on

flash:
	cp -f BOOT.bin $(SDCARD)
	sync $(SDCARD)

gui:
	vivado fpga/fpga.xpr

.PHONY: clean gui project bootgen sdcard vitis impl

