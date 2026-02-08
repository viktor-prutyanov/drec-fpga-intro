obj-m := hello.o

KERNELDIR ?= /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

all:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

test: test.c
	$(CC) test.c -o test

clean:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) clean
	rm -f test
