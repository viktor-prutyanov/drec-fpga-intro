SIM ?= verilator
WAVES ?= 0
COV ?= 0

VERILOG_SOURCES :=  \
	src/peb.sv \
	src/sqr.sv \

.PHONY: lint

MODULE   = sqr_tb
TOPLEVEL = sqr

ifeq ($(WAVES),1)
	EXTRA_ARGS += --trace --trace-structs
endif

ifeq ($(COV),1)
	EXTRA_ARGS += --coverage
endif

include $(shell cocotb-config --makefiles)/Makefile.sim

lint: $(VERILOG_SOURCES)
	verilator --lint-only $^