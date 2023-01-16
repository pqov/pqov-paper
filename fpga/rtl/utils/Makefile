CC = iverilog
CC_FLAGS = -Wall -DSIMULATION

all : tb_test.sim

tb_test.sim : tb/*.v rtl/*.v
	$(CC) $(CC_FLAGS) -o test.sim $^

test : tb_test.sim
	./test.sim

clean :
	rm -f test.sim

