SIM ?= verilator
WAVES ?= 0
COV ?= 0

VERILOG_SOURCES :=  \
	src/axil2reg_rd.sv \
	src/axil2reg_wr.sv \
	src/axil2reg.sv    \
	src/axil2reg_inc.sv

.PHONY: lint

MODULE   = axil2reg_inc_tb
TOPLEVEL = axil2reg_inc

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