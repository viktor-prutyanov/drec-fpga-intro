LINUX ?= linux-xlnx
UBOOT = u-boot-xlnx
DTXLNX = device-tree-xilinx
KDIR = $(LINUX)/build
UIMAGE = $(LINUX)/build/arch/arm/boot/uImage

obj-m := axi-scale-drv.o
PWD := $(shell pwd)

export CROSS_COMPILE = arm-linux-gnueabihf-

all: project impl vitis dtb uboot linux bootgen uramdisk.image.gz boot.scr

download:
	wget https://xilinx-wiki.atlassian.net/wiki/download/attachments/18842473/arm_ramdisk.image.gz -O ramdisk.image.gz
	git clone --branch xilinx-v2025.2 --depth 1 org-3189299@github.com:Xilinx/linux-xlnx.git $(LINUX)
	git clone --branch xilinx-v2025.2 --depth 1 org-3189299@github.com:Xilinx/u-boot-xlnx.git $(UBOOT)
	git clone --branch xlnx_rel_v2025.2 org-3189299@github.com:Xilinx/device-tree-xlnx.git $(DTXLNX)

uramdisk.image.gz: ramdisk.image.gz
	mkimage -A arm -T ramdisk -C gzip -d ramdisk.image.gz uramdisk.image.gz

boot.scr: boot.cmd
	mkimage -A arm -T script -d boot.cmd boot.scr

clean:
	-$(MAKE) -C $(KDIR) M=$(PWD) ARCH=arm clean
	-$(MAKE) -f cocotb.mk clean
	rm -rf results.xml
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

dts:
	cp vitis/zynq_platform/export/zynq_platform/sw/boot/system.dtb system.dtb
	dtc -I dtb -O dts -o system.dts system.dtb
	patch < key.dts.patch
	dtc -I dts -O dtb -o system.dtb system.dts

linux:
	make -C $(LINUX) O=build ARCH=arm xilinx_zynq_defconfig
	make -C $(LINUX) O=build ARCH=arm UIMAGE_LOADADDR=0x8000 -j`nproc` uImage
	make -C $(LINUX) O=build ARCH=arm -j`nproc` modules

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
	cp -f axi-scale-drv.ko $(SDCARD)
	sync $(SDCARD)

gui:
	vivado fpga/fpga.xpr

driver:
	$(MAKE) -C $(KDIR) M=$(PWD) ARCH=arm modules

.PHONY: all clean gui project bootgen flash vitis impl xsct dtb linux uboot download driver

