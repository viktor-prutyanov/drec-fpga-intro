SIM ?= verilator # Симулятор

TOPLEVEL_LANG = verilog

VERILOG_SOURCES += \
	src/counter.sv    # Список HDL-файлов

TOPLEVEL = counter	  # Тестируемый модуль
MODULE   = counter_tb # Тестбенч

ifeq ($(SIM), verilator) # Сохранение всех сигналов в .fst файл
	EXTRA_ARGS += --trace --trace-fst --trace-structs
endif

include $(shell cocotb-config --makefiles)/Makefile.sim # Makefile из cocotb