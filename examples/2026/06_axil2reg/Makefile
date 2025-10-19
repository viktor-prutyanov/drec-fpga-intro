SIM ?= verilator
WAVES ?= 0
COV ?= 0

VERILOG_SOURCES :=  \
	src/axil2reg_rd.sv \
	src/axil2reg_wr.sv \
	src/axil2reg.sv    \

.PHONY: lint

lint: $(VERILOG_SOURCES)
	verilator --lint-only $^