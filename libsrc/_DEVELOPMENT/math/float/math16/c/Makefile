# Helper makefile to generate the checked in .asm files

CFILES = $(wildcard *.c)
AFILES = $(CFILES:.c=.asm)
CFLAGS += -I.

all: $(addprefix asm/,$(AFILES))

asm/%.asm: %.c
	zcc +z80 -clib=new -O3 --opt-code-speed $(CFLAGS) -a $^ -o $@

clean:
	$(RM) asm/*.asm asm/*.err zcc_opt.def
