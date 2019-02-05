test: pset01
	./pset01

pset01: testbench.v clk_div.v
	iverilog $^ -o $@

clean:
	rm -f pset00

help:
	@echo "  test  - Run testbench"
	@echo "  clean - Remove most generated files"
	@echo "  help  - Display this text"

.PHONY: clean test help
