vsim:
	vlog hello.cpp dpi_tb.sv
	vsim work.dpi_tb -c -do "run -all; exit"

verilator:
	verilator --binary hello.cpp dpi_tb.sv
	./obj_dir/Vdpi_tb

clean:
	rm -rf transcript work obj_dir

.PHONY: vsim verilator clean