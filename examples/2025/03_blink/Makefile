gui:
	quartus fpga &

syn:
	quartus_sh --flow compile fpga

fpga:
	quartus_pgm -c "USB-Blaster" -m JTAG -o "p;output/fpga.sof"

drc:
	quartus_drc fpga

clean:
	rm -rf db incremental_db output fpga.qws greybox_tmp *.bak

.PHONY: syn fpga clean gui drc
