PROJ := 11_uart_mmio

test: $(PROJ)
	./$(PROJ)

$(PROJ): testbench.v cpu_top.v core.v alu.v reg_file.v control.v rom.v mem_ctrl.v uart_tx.v
	$(MAKE) -C samples/
	iverilog $^ -o $@

clean:
	rm -f $(PROJ) dump.vcd

help:
	@echo "  test  - Run testbench"
	@echo "  clean - Remove most generated files"
	@echo "  help  - Display this text"

.PHONY: clean test help
