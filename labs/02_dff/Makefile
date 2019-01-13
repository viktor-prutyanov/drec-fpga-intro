test: lab02_dff
	./lab02_dff

lab02_dff: testbench.v dff.v dff_async_rst.v
	iverilog $^ -o $@

clean:
	rm -f lab02_dff

help:
	@echo "  test  - Run testbench"
	@echo "  clean - Remove most generated files"
	@echo "  help  - Display this text"

.PHONY: clean test help
