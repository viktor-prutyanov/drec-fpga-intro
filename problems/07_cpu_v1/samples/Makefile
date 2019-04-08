RISCV_PREFIX=riscv64-linux-gnu-

AS=$(RISCV_PREFIX)as
LD=$(RISCV_PREFIX)ld
OBJCOPY=$(RISCV_PREFIX)objcopy
OBJDUMP=$(RISCV_PREFIX)objdump

SRCS=$(wildcard *.s)
TXTS=$(SRCS:%.s=%.txt)

all: $(TXTS)

%.txt: %.bin
	hexdump -v -e '"%08x\n"' $^ > $@

%.bin: %.out
	$(OBJCOPY) -O binary $^ $@

%.out: %.o
	$(LD) -melf32lriscv $^ -o $@ && $(OBJDUMP) -d $@

%.o: %.s
	$(AS) -march=rv32i -mabi=ilp32 -c $^ -o $@

.PHONY: all clean

.PRECIOUS: %.o %.out %.bin

clean:
	rm -f *.o *.out *.bin *.txt
