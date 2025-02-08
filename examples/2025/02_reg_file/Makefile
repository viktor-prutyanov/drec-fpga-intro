TB_LIST := 

RTL_LIST := reg_file.v

PROJ := reg_file

sim: $(TB_LIST) $(RTL_LIST)
	iverilog $^ -o sim
	./sim

waves: dump.vcd
	gtkwave dump.vcd &

syn:
	quartus_sh --flow compile $(PROJ)

gui:
	quartus $(PROJ) &

clean:
	rm -rf sim dump.vcd
	rm -rf db incremental_db output $(PROJ).qws *.bak

.PHONY: syn clean gui sim waves
