.PHONY: vcs sim clean

TEST_DESIGN = comparator_32bit_v_38

vcs:
    vcs -sverilog +v2k -timescale=1ns/1ns       \
    -debug_all         							\
    -l compile.log 								\
    ${TEST_DESIGN}.v testbench.v

sim:
    ./simv -l run.log

clean:
    rm -rf *.log  csrc  simv*  *.key *.vpd  DVEfiles coverage *.vdb output.txt