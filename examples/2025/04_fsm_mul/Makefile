TB_LIST := mul_tb.v

RTL_LIST := mul.v

sim: $(TB_LIST) $(RTL_LIST)
	iverilog $^ -o sim
	./sim

waves: dump.vcd
	gtkwave dump.vcd &

syn:
	quartus_sh --flow compile fpga

gui:
	quartus fpga &

lint:
	verilator --lint-only $(RTL_LIST)

clean:
	rm -rf sim dump.vcd
	rm -rf db incremental_db output fpga.qws

.PHONY: syn clean samples gui sim waves lint
