test: lab01_adder
	./lab01_adder

lab01_adder: adder.v
	iverilog $^ -o $@

clean:
	rm -f lab01_adder

help:
	@echo "  test  - Run testbench"
	@echo "  clean - Remove most generated files"
	@echo "  help  - Display this text"

.PHONY: clean test help
