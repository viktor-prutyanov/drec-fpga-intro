test: lab03_counter
	./lab03_counter

lab03_counter: testbench.v counter.v
	iverilog $^ -o $@

clean:
	rm -f lab03_counter

help:
	@echo "  test  - Run testbench"
	@echo "  clean - Remove most generated files"
	@echo "  help  - Display this text"

.PHONY: clean test help
