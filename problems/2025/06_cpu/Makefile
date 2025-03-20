ifeq ($(FULL),1)

TOP_TB_NAME := fpga_top_tb

TB_LIST := src/fpga_top_tb.v

RTL_LIST :=             \
	src/fpga_top.v      \
	src/system_top.v    \
	src/mmio_xbar.v     \
	src/ctrl_74hc595.v  \
	src/hex_display.v   \

else

TOP_TB_NAME := cpu_top_tb

TB_LIST := src/cpu_top_tb.v

RTL_LIST :=

endif

RTL_LIST += 		\
	src/cpu_top.v	\
	src/core.v		\
	src/alu.v		\
	src/cmp.v		\
	src/reg_file.v	\
	src/control.v	\
	src/imem.v		\
	src/dmem.v		\
	src/mem_xbar.v	\
	src/lsu.v		\
	src/mux4.v		\

ifeq ($(GUI), 1)
VSIM_FLAGS :=
else
VSIM_FLAGS := -c
endif

ifeq ($(GATE), 1)
VSIM_DIR   	:= simulation/questa
VCD_FILE   	:= $(VSIM_DIR)/fpga.vcd
VSIM_SCRIPT := fpga_run_msim_gate_verilog.do
VSIM_FLAGS 	+= -do $(VSIM_SCRIPT)
else ifeq ($(GATE), 0)
VSIM_DIR   	:= simulation/questa
VCD_FILE   	:= $(VSIM_DIR)/dump.vcd
VSIM_SCRIPT := fpga_run_msim_rtl_verilog.do
VSIM_FLAGS 	+= -do $(VSIM_SCRIPT)
else
VCD_FILE 	:= dump.vcd
VSIM_FLAGS 	+= -do 'run -all'
endif

sim: $(TB_LIST) $(RTL_LIST)
	iverilog -s $(TOP_TB_NAME) -I./src/ $^ -o sim
	./sim

vsim: $(TB_LIST) $(RTL_LIST)
ifdef GATE
	env -C $(VSIM_DIR) vsim $(VSIM_FLAGS)
else
	vlog $^ src/altera/*.v
	vsim work.$(TOP_TB_NAME) $(VSIM_FLAGS) -L altera_mf_ver
endif

waves: $(VCD_FILE)
	gtkwave $(VCD_FILE) &

syn:
	quartus_sh --flow compile fpga

gui:
	quartus fpga &

fpga:
	quartus_pgm -c "USB-Blaster" -m JTAG -o "p;output/fpga.sof"

drc:
	quartus_drc fpga

pow: $(VSIM_DIR)/fpga.vcd
	quartus_pow fpga

samples:
	$(MAKE) -C samples/

clean:
	rm -rf sim dump.vcd
	rm -rf db incremental_db output fpga.qws greybox_tmp *.bak
	rm -rf work transcript *.ver *.rpt simulation *.wlf *.ini gate_work rtl_work
	$(MAKE) -C samples/ clean

.PHONY: syn fpga clean samples gui sim waves vsim
