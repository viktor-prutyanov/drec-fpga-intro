obj-m := hello-mmio.o

PWD := $(shell pwd)

KERNELDIR ?= ${PWD}/../09_ps7_axi_led/linux-xlnx/build

all:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) ARCH=arm CROSS_COMPILE=$(CROSS_COMPILE) modules

clean:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) ARCH=arm CROSS_COMPILE=$(CROSS_COMPILE) clean

