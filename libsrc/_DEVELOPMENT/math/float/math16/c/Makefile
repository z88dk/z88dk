# Helper makefile to generate the checked in .asm files

CFILES = $(wildcard *.c)
AFILES = $(CFILES:.c=.asm)
CFLAGS += -Cc-D__MATH_MATH16 -D__MATH_MATH16 -I. 

all: $(addprefix asm/,$(AFILES))

asm/%.asm: %.c
	zcc +z80 -clib=new -O1 --opt-code-speed=inlineints $(CFLAGS) -a $^ -o $@

clean:
	$(RM) asm/*.asm asm/*.err zcc_opt.def
