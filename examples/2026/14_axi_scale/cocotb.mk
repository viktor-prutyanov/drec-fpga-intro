SIM ?= icarus
WAVES ?= 0
COV ?= 0

VERILOG_SOURCES :=  \
	src/axil2reg_wr.sv \
	src/data_buf.sv \
	src/addr_gen.sv \
	src/axi_scale.v \

.PHONY: lint

MODULE   = axi_scale_tb
TOPLEVEL = axi_scale

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
	verilator --lint-only $(VERILOG_SOURCES)
