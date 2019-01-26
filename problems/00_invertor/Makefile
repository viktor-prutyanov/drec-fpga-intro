test: pset00
	./pset00

pset00: testbench.v pset00_test.v
	iverilog $^ -o $@

clean:
	rm -f pset00

help:
	@echo "  test  - Run testbench"
	@echo "  clean - Remove most generated files"
	@echo "  help  - Display this text"

.PHONY: clean test help
