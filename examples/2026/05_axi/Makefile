SIM ?= verilator
WAVES ?= 0
COV ?= 0

VERILOG_SOURCES :=  \
	src/ctrl.sv \
	src/peb.sv \
	src/inc.sv \
	src/axi_inc.sv \

.PHONY: lint

MODULE   = axi_inc_tb
TOPLEVEL = axi_inc

ifeq ($(SIM),verilator)
ifeq ($(WAVES),1)
	EXTRA_ARGS += --trace --trace-fst --trace-structs
endif
ifeq ($(COV),1)
	EXTRA_ARGS += --coverage
endif
endif

include $(shell cocotb-config --makefiles)/Makefile.sim

lint: $(VERILOG_SOURCES)
	verilator --lint-only $^