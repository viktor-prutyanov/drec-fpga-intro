SIM ?= verilator

TOPLEVEL_LANG = verilog

VERILOG_SOURCES += \
	src/counter.sv

COCOTB_TOPLEVEL = counter

COCOTB_TEST_MODULES = counter_tb

ifeq ($(SIM), verilator)
	EXTRA_ARGS += --trace --trace-fst --trace-structs
endif

include $(shell cocotb-config --makefiles)/Makefile.sim