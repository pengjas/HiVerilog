.PHONY: vcs sim  verdi clean 

TEST_DESIGN = accu

vcs:
		vcs +vcs+lic+wait -sverilog -full64 -debug_access+classdbg -debug_all \
		-f ./sim.f -R -l compile.log

sim:
		./simv -l run.log

verdi:
	verdi -sv -f ./sim.f -ssf ./tb.fsdb &

clean:
		rm -rf *.log  csrc  simv*  *.key *.vpd  DVEfiles coverage *.vdb output.txt
