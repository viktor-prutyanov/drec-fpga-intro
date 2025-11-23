LINUX = linux-xlnx
UBOOT = u-boot-xlnx
DTXLNX = device-tree-xilinx

UIMAGE = $(LINUX)/build/arch/arm/boot/uImage

export CROSS_COMPILE = arm-linux-gnueabihf-

download:
	wget https://xilinx-wiki.atlassian.net/wiki/download/attachments/18842473/arm_ramdisk.image.gz -O ramdisk.image.gz 
	git clone --branch xilinx-v2025.1 --depth 1 org-3189299@github.com:Xilinx/linux-xlnx.git $(LINUX)
	git clone --branch xilinx-v2025.1 --depth 1 org-3189299@github.com:Xilinx/u-boot-xlnx.git $(UBOOT)
	git clone --branch xlnx_rel_v2025.1 org-3189299@github.com:Xilinx/device-tree-xlnx.git $(DTXLNX)

uramdisk.image.gz:
	mkimage -A arm -T ramdisk -C gzip -d ramdisk.image.gz uramdisk.image.gz

clean:
	rm -rf *.log *.jou .Xil
	rm -rf fpga
	rm -rf vitis
	rm -rf *.dtsi *.dtb *.dts *.mss include
	rm -rf BOOT.bin
	rm -rf uramdisk.image.gz
	rm -rf $(LINUX)/build
	rm -rf $(UBOOT)/build

project:
	vivado -mode batch -source project.tcl

impl:
	vivado -mode batch -source impl.tcl

vitis:
	vitis -s build.py

dts:
	xsct dts.tcl

dtb:
	gcc -I. -E -nostdinc -undef -D__DTS__ -x assembler-with-cpp -o system.dts system-top.dts
	dtc -I dts -O dtb -o system.dtb system.dts

linux:
	make -C $(LINUX) O=build ARCH=arm xilinx_zynq_defconfig
	make -C $(LINUX) O=build ARCH=arm UIMAGE_LOADADDR=0x8000 -j`nproc` uImage

uboot:
	make -C $(UBOOT) O=build ARCH=arm xilinx_zynq_virt_defconfig
	mkdir -p $(UBOOT)/build/arch/arm/dts
	cp system.dtb $(UBOOT)/build/arch/arm/dts
	make -C $(UBOOT) O=build ARCH=arm DEVICE_TREE=system -j`nproc`

bootgen:
	bootgen -image input.bif -arch zynq -o BOOT.bin -w on

flash:
	cp -f BOOT.bin $(SDCARD)
	cp -f system.dtb $(SDCARD)
	cp -f $(UIMAGE) $(SDCARD)
	cp -f uramdisk.image.gz $(SDCARD)
	sync $(SDCARD)

gui:
	vivado fpga/fpga.xpr

.PHONY: clean gui project bootgen flash vitis impl dtb linux uboot download

