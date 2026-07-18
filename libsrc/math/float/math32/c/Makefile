# Helper makefile to generate the checked in .asm files
#
# Z80:  SDCC  → asm/   (c/asm/… listed by newlibfiles_z80.lst)
# 8085: sccz80 only → 8085/  (listed by newlibfiles_8085.lst)
#       Same pattern as am9511/c/Makefile — do not use zsdcc/SDCC for 8085.

CFILES = $(wildcard *.c)
AFILES = $(CFILES:.c=.asm)
CFLAGS += -I.

all: $(addprefix asm/,$(AFILES))

asm/%.asm: %.c
	zcc +z80 -clib=sdcc_ix --reserve-regs-iy --allow-unsafe-read --max-allocs-per-node400000 -D__MATH_MATH32 -SO3 $(CFLAGS) -a $^ -o $@

# 8085 higher functions: sccz80 only (zsdcc is Z80-only)
CFILES8085 = $(wildcard *.c)
AFILES8085 = $(CFILES8085:.c=.asm)

8085: $(addprefix 8085/,$(AFILES8085))

8085/%.asm: %.c
	@mkdir -p 8085
	zcc +test -clib=8085 -compiler=sccz80 -fp-mode=ieee -D__MATH_MATH32 \
	    -O2 --opt-code-speed=all -I. $(CFLAGS) -a $^ -o $@

clean:
	$(RM) asm/*.asm asm/*.err zcc_opt.def
	$(RM) 8085/*.asm 8085/*.err
