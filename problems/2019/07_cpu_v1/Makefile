PSET := pset07

test: $(PSET)
	./$(PSET) | tee cpu.log
	grep "CPUv1" cpu.log | diff cpu_test.log -

$(PSET): testbench.v cpu_top.v core.v alu.v reg_file.v control.v rom.v
	iverilog $^ -o $@

clean:
	rm -f $(PSET)

help:
	@echo "  test  - Run testbench"
	@echo "  clean - Remove most generated files"
	@echo "  help  - Display this text"

.PHONY: clean test help out.txt
