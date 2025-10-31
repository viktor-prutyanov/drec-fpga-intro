TOP_TB_NAME := cnt_tb

TB_LIST := src/cnt_tb.sv

RTL_LIST :=  \
	src/cnt.sv \

FPGA_RTL_LIST := \
	src/fpga_top.v

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

lint: $(FPGA_RTL_LIST) $(RTL_LIST)
	verilator --lint-only $^

clean:
	rm -rf transcript work obj_dir *.log *.jou *.vcd .Xil fpga

waves: $(VCD_FILE)
	gtkwave $(VCD_FILE) &

project:
	vivado -mode batch -source project.tcl

gui:
	vivado fpga/fpga.xpr

.PHONY: clean verilator lint gui waves vsim project fpga

