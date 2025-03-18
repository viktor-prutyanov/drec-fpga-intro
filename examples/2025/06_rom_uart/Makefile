TOP_TB_NAME := tb

TB_LIST := fpga_top_tb.v

RTL_LIST :=     	\
    fpga_top.v  	\
    uart_tx.v   	\
    counter.v   	\
    rom1r_wrap.v	\

ifeq ($(GUI), 1)
VSIM_FLAGS :=
else
VSIM_FLAGS := -c
endif

ifeq ($(FULL),1)
ifeq ($(GATE), 1)
VSIM_DIR   	:= simulation/questa
VCD_FILE   	:= $(VSIM_DIR)/fpga.vcd
VSIM_FLAGS 	+= -do fpga_run_msim_gate_verilog.do
else
VSIM_DIR   	:= simulation/questa
VCD_FILE   	:= $(VSIM_DIR)/dump.vcd
VSIM_FLAGS 	+= -do fpga_run_msim_rtl_verilog.do
endif
else
VCD_FILE 	:= dump.vcd
VSIM_FLAGS 	+= -do 'run -all'
endif

sim: $(TB_LIST) $(RTL_LIST)
	iverilog -s $(TOP_TB_NAME) $^ -o sim
	./sim

vsim: $(TB_LIST) $(RTL_LIST)
ifeq ($(FULL),1)
	env -C $(VSIM_DIR) vsim $(VSIM_FLAGS) 
else
	vlog $^ altera/*.v
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

clean:
	rm -rf sim dump.vcd
	rm -rf db incremental_db output fpga.qws greybox_tmp *.bak
	rm -rf work transcript *.ver *.rpt simulation *.wlf

.PHONY: syn fpga clean samples gui sim waves vsim
