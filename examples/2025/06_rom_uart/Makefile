TOP_TB_NAME := tb

TB_LIST := fpga_top_tb.v

RTL_LIST := 	\
	fpga_top.v	\
	uart_tx.v	\
	counter.v	\

ifeq ($(GUI), 1)
VSIM_FLAGS :=
else
VSIM_FLAGS := -c
endif

sim: $(TB_LIST) $(RTL_LIST)
	iverilog -s $(TOP_TB_NAME) $^ -o sim
	./sim

ifeq ($(FULL),1)
ifeq ($(RTL),1)
vsim: $(TB_LIST) $(RTL_LIST) simulation/questa/fpga_run_msim_rtl_verilog.do
	env -C simulation/questa vsim $(VSIM_FLAGS) -do fpga_run_msim_rtl_verilog.do
else ifeq ($(GATE), 1)
vsim: $(TB_LIST) simulation/questa/fpga.vo simulation/questa/fpga_v.sdo simulation/questa/fpga_run_msim_gate_verilog.do
	env -C simulation/questa vsim $(VSIM_FLAGS) -do fpga_run_msim_gate_verilog.do
endif
else
vsim: $(TB_LIST) $(RTL_LIST)
	vlog $^ altera/*.v
	vsim $(VSIM_FLAGS) work.$(TOP_TB_NAME) -L altera_mf_ver -do 'run -all'
endif

waves: dump.vcd
	gtkwave dump.vcd &

syn:
	quartus_sh --flow compile fpga

gui:
	quartus fpga &

fpga:
	quartus_pgm -c "USB-Blaster" -m JTAG -o "p;output/fpga.sof"

drc:
	quartus_drc fpga

pow: simulation/questa/fpga.vcd
	quartus_pow fpga

clean:
	rm -rf sim dump.vcd
	rm -rf db incremental_db output fpga.qws greybox_tmp *.bak
	rm -rf work transcript *.ver *.rpt simulation *.wlf

.PHONY: syn fpga clean samples gui sim waves vsim
