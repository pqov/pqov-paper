DEVICE=stm32l4r5zi
LDSCRIPT=nucleo-l4r5zi.ld
LIBNAME=opencm3_stm32l4
OPENCM3_DIR = ../../../pqm4/libopencm3
DEFINES=-DSTM32L4R5ZI -DSTM32L4
ARCH_FLAGS = -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16

CROSS_PREFIX ?= arm-none-eabi
CC := $(CROSS_PREFIX)-gcc
CPP := $(CROSS_PREFIX)-cpp
AR := $(CROSS_PREFIX)-gcc-ar
LD := $(CC)
OBJCOPY := $(CROSS_PREFIX)-objcopy
SIZE := $(CROSS_PREFIX)-size

CFLAGS	+= -O3 \
		   -Wall -Wextra -Wimplicit-function-declaration \
		   -Wredundant-decls -Wmissing-prototypes -Wstrict-prototypes \
		   -Wundef -Wshadow \
		   -I$(OPENCM3_DIR)/include -Icommon/ -I../ -I../../crypto_sign/uov-I-gf16/ref-flash/\
		   -fno-common $(ARCH_FLAGS) -MD $(DEFINES)

LDFLAGS += \
	--specs=nosys.specs \
	-Wl,--wrap=_sbrk \
	-nostartfiles \
	-ffreestanding \
	-T$(LDSCRIPT) \
	-L$(OPENCM3_DIR)/lib \
	$(ARCH_FLAGS)

OBJS=common/hal-opencm3.o common/randombytes.o common/aes.o common/aes-keyschedule.S common/aes-encrypt.S
OBJS+=aes4-publicinputs.o aes4-publicinputs.S

all: lib test-aes.hex

lib:
	make -C $(OPENCM3_DIR)

%.bin: %.elf
	$(OBJCOPY) -Obinary $< $@

%.hex: %.elf
	$(OBJCOPY) -Oihex $< $@

%.elf: %.o $(OBJS) $(LDSCRIPT)
	$(LD) -o $(*).elf $(*).o $(OBJS) $(LDFLAGS) -l$(LIBNAME)

%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

clean:
	find . -name \*.o -type f -exec rm -f {} \;
	find . -name \*.d -type f -exec rm -f {} \;
	rm -f *.elf
	rm -f *.bin
	rm -f *.hex