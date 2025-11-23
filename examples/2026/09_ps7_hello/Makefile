all: project impl vitis bootgen

clean:
	rm -rf *.log *.jou *.str .Xil fpga vitis BOOT.bin

project:
	vivado -mode batch -source project.tcl

impl:
	vivado -mode batch -source impl.tcl

vitis:
	vitis -s build.py

bootgen:
	bootgen -image input.bif -arch zynq -o BOOT.bin -w on

flash:
	rm -rf $(SDCARD)/*
	cp -f BOOT.bin $(SDCARD)
	sync $(SDCARD)

gui:
	vivado fpga/fpga.xpr

.PHONY: all clean gui project bootgen flash vitis impl

