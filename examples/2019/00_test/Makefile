test: lab00_test
	./lab00_test

lab00_test: testbench.v lab00_test.v
	iverilog $^ -o $@

clean:
	rm -f lab00_test

help:
	@echo "  test  - Run testbench"
	@echo "  clean - Remove most generated files"
	@echo "  help  - Display this text"

.PHONY: clean test help
