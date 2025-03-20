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
VCD_FILE   	:= $(VSIM_DIR)/dump.vcd
VSIM_FLAGS 	+= +transport_int_delays +transport_path_delays
else
VCD_FILE 	:= dump.vcd
endif

VSIM_FLAGS += -do 'run -all'

VSIM_LIBS :=            \
    altera_ver          \
    lpm_ver             \
    sgate_ver           \
    altera_mf_ver       \
    altera_lnsim_ver    \
    cycloneive_ver      \

VSIM_LIBS := $(patsubst %,-L %,$(VSIM_LIBS))

sim: $(TB_LIST) $(RTL_LIST)
ifeq ($(GATE), 1)
	$(error Icarus Verilog doesn't support GLS)
else
	iverilog -s $(TOP_TB_NAME) -I./src/ $^ -o sim
	./sim
endif

vsim: $(TB_LIST) $(RTL_LIST)
ifeq ($(GATE), 1)
	env -C $(VSIM_DIR) vlog $(realpath $(TB_LIST)) fpga.vo
	env -C $(VSIM_DIR) vsim work.$(TOP_TB_NAME) $(VSIM_FLAGS) $(VSIM_LIBS)
else
	vlog $^ src/altera/*.v
	vsim work.$(TOP_TB_NAME) $(VSIM_FLAGS) $(VSIM_LIBS)
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

samples:
	$(MAKE) -C samples/

clean:
	rm -rf sim dump.vcd
	rm -rf db incremental_db output fpga.qws greybox_tmp *.bak
	rm -rf work transcript *.ver *.rpt simulation *.wlf *.ini gate_work rtl_work
	$(MAKE) -C samples/ clean

.PHONY: syn fpga clean samples gui sim waves vsim
