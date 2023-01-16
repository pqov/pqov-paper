TRNG_SRC=rtl/TRNG.v
AES_CORE_SRC=rtl/aes_core.v
AES_EB_SRC=rtl/aes_encipher_block.v
AES_CB_SRC=rtl/aes_decipher_block.v
AES_IB_SRC=rtl/aes_inv_sbox.v
AES_KM_SRC=rtl/aes_key_mem.v
AES_SB_SRC=rtl/aes_sbox.v
AES_DRBG_SRC=rtl/aes_ctr_drbg.v

TB_TRNG_SRC=tb/tb_TRNG.v
TB_DRBG_SRC=tb/tb_aes_ctr_drbg.v

CC = iverilog
CC_FLAGS = -Wall -DSIMULATION

all : tb_TRNG.sim tb_drbg.sim

tb_TRNG.sim : $(TRNG_SRC) $(TB_TRNG_SRC)
	$(CC) $(CC_FLAGS) -o tb_TRNG.sim $(TRNG_SRC) $(TB_TRNG_SRC)

tb_drbg.sim : $(TRNG_SRC) $(TB_DRBG_SRC) $(AES_CORE_SRC) $(AES_EB_SRC) $(AES_CB_SRC) $(AES_IB_SRC) $(AES_KM_SRC) $(AES_SB_SRC) $(AES_DRBG_SRC)
	$(CC) $(CC_FLAGS) -o tb_drbg.sim $(TRNG_SRC) $(TB_DRBG_SRC) $(AES_CORE_SRC) $(AES_EB_SRC) $(AES_CB_SRC) $(AES_IB_SRC) $(AES_KM_SRC) $(AES_SB_SRC) $(AES_DRBG_SRC)

sim-TRNG : tb_TRNG.sim
	./tb_TRNG.sim

sim-DRBG : tb_drbg.sim
	./tb_drbg.sim

clean :
	rm -f tb_TRNG.sim
	rm -f tb_drbg.sim
	rm -f *.vcd

