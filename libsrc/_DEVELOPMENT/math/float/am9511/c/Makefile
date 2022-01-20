# Helper makefile to generate the checked in .asm files

CFILES = $(wildcard *.c)
AFILES = $(CFILES:.c=.asm)

z80: $(addprefix z80/,$(AFILES))

8085: $(addprefix 8085/,$(AFILES))

z80/%.asm: %.c
	zcc +z80 -clib=sdcc_ix --reserve-regs-iy --allow-unsafe-read --max-allocs-per-node400000 -D__MATH_AM9511 -SO3 -I. -a $^ -o $@

8085/%.asm: %.c
	zcc +test -clib=8085 --math-am9511_8085 -O2 -I. -a $^ -o $@

clean:
	$(RM) z80/*.asm 8085/*.asm
