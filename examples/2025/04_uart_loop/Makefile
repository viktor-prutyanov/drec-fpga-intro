syn:
	quartus_sh --flow compile fpga

gui:
	quartus fpga &

fpga:
	quartus_pgm -c "USB-Blaster" -m JTAG -o "p;output/fpga.sof"

drc: syn
	quartus_drc fpga

clean:
	rm -rf db incremental_db output fpga.qws *.bak

.PHONY: syn fpga clean gui drc
