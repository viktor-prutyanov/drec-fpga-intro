PSET := pset04

test: $(PSET)
	./$(PSET)

$(PSET): testbench.v top.v clk_div.v hex_display.v
	iverilog $^ -o $@

clean:
	rm -f $(PSET)

help:
	@echo "  test  - Run testbench"
	@echo "  clean - Remove most generated files"
	@echo "  help  - Display this text"

.PHONY: clean test help
