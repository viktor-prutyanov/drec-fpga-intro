LINUX = linux-xlnx
UBOOT = u-boot-xlnx
DTXLNX = device-tree-xilinx

UIMAGE = $(LINUX)/build/arch/arm/boot/uImage

export CROSS_COMPILE = arm-linux-gnueabihf-

all: project impl vitis dtb uboot linux bootgen uramdisk.image.gz boot.scr

download:
	wget https://xilinx-wiki.atlassian.net/wiki/download/attachments/18842473/arm_ramdisk.image.gz -O ramdisk.image.gz 
	git clone --branch xilinx-v2025.1 --depth 1 org-3189299@github.com:Xilinx/linux-xlnx.git $(LINUX)
	git clone --branch xilinx-v2025.1 --depth 1 org-3189299@github.com:Xilinx/u-boot-xlnx.git $(UBOOT)
	git clone --branch xlnx_rel_v2025.1 org-3189299@github.com:Xilinx/device-tree-xlnx.git $(DTXLNX)

uramdisk.image.gz: ramdisk.image.gz
	mkimage -A arm -T ramdisk -C gzip -d ramdisk.image.gz uramdisk.image.gz

boot.scr: boot.cmd
	mkimage -A arm -T script -d boot.cmd boot.scr

clean:
	rm -rf *.log *.jou .Xil
	rm -rf fpga
	rm -rf vitis
	rm -rf *.dtsi *.dtb *.dts *.mss include
	rm -rf BOOT.bin
	rm -rf uramdisk.image.gz boot.scr
	rm -rf $(LINUX)/build
	rm -rf $(UBOOT)/build

project:
	vivado -mode batch -source project.tcl

impl:
	vivado -mode batch -source impl.tcl

vitis:
	vitis -s build.py

xsct:
	xsct dts.tcl
	gcc -I. -E -nostdinc -undef -D__DTS__ -x assembler-with-cpp -o system.dts system-top.dts
	dtc -I dts -O dtb -o system.dtb system.dts

dtb:
	cp vitis/zynq_platform/export/zynq_platform/sw/boot/system.dtb system.dtb

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
	rm -rf $(SDCARD)/*
	cp -f BOOT.bin $(SDCARD)
	cp -f system.dtb $(SDCARD)
	cp -f $(UIMAGE) $(SDCARD)
	cp -f uramdisk.image.gz $(SDCARD)
	cp -f boot.scr $(SDCARD)
	sync $(SDCARD)

gui:
	vivado fpga/fpga.xpr

.PHONY: all clean gui project bootgen flash vitis impl xsct dtb linux uboot download

