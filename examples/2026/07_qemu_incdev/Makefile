ARM_PREFIX ?= arm-none-eabi-

AS=$(ARM_PREFIX)as
LD=$(ARM_PREFIX)ld
CC=$(ARM_PREFIX)gcc
OBJCOPY=$(ARM_PREFIX)objcopy
OBJDUMP=$(ARM_PREFIX)objdump
READELF=$(ARM_PREFIX)readelf

all:
	$(AS) start.s -o start.o
	$(CC) hello.c -g -c -o hello.o
	$(LD) -T virt.ld hello.o start.o -o hello.elf
	$(OBJCOPY) -O binary hello.elf hello.bin
	$(OBJDUMP) -d --visualize-jumps hello.elf

clean:
	rm -f *.o *.elf *.bin
