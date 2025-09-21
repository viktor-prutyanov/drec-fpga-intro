TOP_TB_NAME := sa_dummy_tb

TB_LIST := src/sa_dummy_tb.sv

RTL_LIST :=  \
	src/pe.sv \
	src/sa_core.sv \
	src/sa_top.sv \
	src/delay_line.sv \

VCD_FILE := dump.vcd

ifeq ($(GUI), 1)
VSIM_FLAGS :=
else
VSIM_FLAGS := -c -do 'vcd file $(VCD_FILE); vcd add -r /$(TOP_TB_NAME)/*; run -all'
endif

vsim: $(TB_LIST) $(RTL_LIST)
	vlog $^
	vsim work.$(TOP_TB_NAME) $(VSIM_FLAGS) $(VSIM_LIBS)

verilator: $(TB_LIST) $(RTL_LIST)
	verilator --binary -Wno-fatal $^
	./obj_dir/V$(TOP_TB_NAME)

clean:
	rm -rf transcript work obj_dir

waves: $(VCD_FILE)
	gtkwave $(VCD_FILE) &

.PHONY: clean verilator waves vsim