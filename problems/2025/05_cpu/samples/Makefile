RISCV_PREFIX=riscv64-unknown-elf-

AS=$(RISCV_PREFIX)as
LD=$(RISCV_PREFIX)ld
CC=$(RISCV_PREFIX)gcc
OBJCOPY=$(RISCV_PREFIX)objcopy
OBJDUMP=$(RISCV_PREFIX)objdump
FUNCSIM=whisper

S_SRCS=$(wildcard *.s)
C_SRCS=$(wildcard *.c)
S_TXTS=$(S_SRCS:%.s=%.txt)
C_TXTS=$(C_SRCS:%.c=%.txt)

all: $(S_TXTS) $(C_TXTS)

%.txt: %.bin
	hexdump -v -e '"%08x\n"' $^ > $@
	python3 nop_pad.py $@

%.bin: %.out
	$(OBJCOPY) -O binary $^ $@

%.out: %.s
	$(AS) -march=rv32i -mabi=ilp32 -c $^ -o $^.o
	$(LD) -melf32lriscv -Map=$^.map $^.o -o $@
	$(OBJDUMP) -d --visualize-jumps -M no-aliases $@

loader.o: loader/loader.s
	$(AS) -march=rv32i -mabi=ilp32 -c loader/loader.s -o loader.o

%.out: %.c loader.o
	$(CC) -nostdlib -march=rv32i -mabi=ilp32 -c $< -o $<.o
	$(LD) -melf32lriscv loader.o $<.o -o $@
	$(OBJDUMP) -d --visualize-jumps -M no-aliases $@

%.out.log: %.out .FORCE
	$(FUNCSIM) -e 0x`riscv64-unknown-elf-readelf -s $< | grep _finish | awk '{ print $$2 }'` -l $< | tee $@

.FORCE:

.PHONY: all clean

.PRECIOUS: %.o %.out %.bin %.txt

clean:
	rm -f *.o *.out *.bin *.txt *.mif *.map *.log
