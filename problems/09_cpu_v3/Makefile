PSET := pset09

test: $(PSET)
	./$(PSET)

$(PSET): testbench.v cpu_top.v core.v alu.v reg_file.v control.v rom.v mem_ctrl.v
	iverilog $^ -o $@

clean:
	rm -f $(PSET)

samples:
	$(MAKE) -C samples/

help:
	@echo "  test  - Run testbench"
	@echo "  clean - Remove most generated files"
	@echo "  help  - Display this text"

.PHONY: clean test help samples
