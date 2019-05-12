# Helper makefile to generate the checked in .asm files

CFILES = $(wildcard *.c)
AFILES = $(CFILES:.c=.asm)
CFLAGS += -I../../../../../../include/_DEVELOPMENT/sdcc/ -I.

all: $(addprefix asm/,$(AFILES))

asm/%.asm: %.c
	zcc +z80 -compiler=sdcc $(CFLAGS) -S $^ -o $@
