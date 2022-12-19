
all: main

SOURCES=main.c x86aesni.c
CFLAGS += -mavx2 -maes
main:
	$(CC) $(CFLAGS) $(SOURCES) -o main


.PHONY: clean

clean:
	rm -rf main