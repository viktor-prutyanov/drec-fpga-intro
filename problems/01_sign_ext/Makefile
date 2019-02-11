test: pset01
	./pset01

pset01: testbench.v sign_ext.v sign_ext2.v neg.v
	iverilog $^ -o $@

clean:
	rm -f pset01

help:
	@echo "  test  - Run testbench"
	@echo "  clean - Remove most generated files"
	@echo "  help  - Display this text"

.PHONY: clean test help
