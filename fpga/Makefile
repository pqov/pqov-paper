# RTL simulation
# May use ncverilog, vcs or iverilog

all: testbench

DEFINE_IVERILOG := -I ./$(RTL_PATH)/ -I ./rtl/sha3/ -DV=$(V) -DO=$(O) -DV_=$(V_) -DO_=$(O_) -DGF_BIT=$(GF_BIT) -DOP_SIZE=$(OP_SIZE) -DN=$N -DL=$L -DL_ORI=$(L_ORI) -DK=$K 
AFTER_COMPILE_IVERILOG := && ./a.out

DEFINE := +incdir+$(RTL_PATH)/ +incdir+rtl/sha3/ +define+V=$(V) +define+O=$(O) +define+V_=$(V_) +define+O_=$(O_) +define+GF_BIT=$(GF_BIT) +define+OP_SIZE=$(OP_SIZE) +define+N=$N +define+L=$L +define+L_ORI=$(L_ORI) +define+K=$K
AFTER_COMPILE := 

ifneq (, $(shell which ncverilog))
CC       := ncverilog
CC_FLAGS := -timescale 1ns/100ps +access+r
else ifneq (, $(shell which vcs))
CC       := vcs
CC_FLAGS := -full64 -R -debug_access+all -sverilog -error=noZMMCM -timescale=1ns/1ps
else ifneq (, $(shell which iverilog))
CC       := iverilog
CC_FLAGS := -Wall -Wno-timescale
DEFINE   := $(DEFINE_IVERILOG)
AFTER_COMPILE := $(AFTER_COMPILE_IVERILOG)
else
$(error "No ncverilog or vcs or iverilog in $(PATH)")
endif

SRC := ./$(RTL_PATH)/*.v ./rtl/sha3/sha3_64.v ./rtl/sha3/keccak_round.v ./rtl/utils/rtl/*.v ./rtl/aes_ctr_rng/rtl/*.v


testbench: $(SRC)
	$(CC) $(CC_FLAGS) $(DEFINE) $^ $(AFTER_COMPILE)

clean:
	rm -rf a.out testbench.vcd
