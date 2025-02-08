TEST_SIZE ?= 4096
TEST_OP   ?= mul
DEBUG     ?= 0

TB_LIST := fp16u_tb.v

RTL_LIST := fp16mul.v fp16add.v

sim: $(TB_LIST) $(RTL_LIST)
	python3 test.py $(TEST_SIZE) $(TEST_OP) > test.txt
	iverilog -g2012 $^ -o sim -DTEST_SIZE=$(TEST_SIZE) -DTEST_OP=$(TEST_OP) -DDEBUG=$(DEBUG)
	./sim

waves: dump.vcd
	gtkwave dump.vcd &

clean:
	rm -rf sim dump.vcd test.txt

.PHONY: clean sim waves
