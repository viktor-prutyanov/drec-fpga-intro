TB_LIST := div3_tb.v

RTL_LIST := div3.v

sim: $(TB_LIST) $(RTL_LIST)
	iverilog $^ -o sim
	./sim

waves: dump.vcd
	gtkwave dump.vcd &

syn:
	quartus_sh --flow compile fpga

gui:
	quartus fpga &

fpga:
	quartus_pgm -c "USB-Blaster" -m JTAG -o "p;output/fpga.sof"

drc: syn
	quartus_drc fpga

clean:
	rm -rf sim dump.vcd
	rm -rf db incremental_db output fpga.qws *.bak

.PHONY: syn fpga clean gui sim waves drc
