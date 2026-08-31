# Helper makefile to generate the checked in .asm files
#
# Z80:  SDCC  → z80/   (c/z80/… listed by newlibfiles_z80.lst)
# 8085: sccz80 only → 8085/  (listed by newlibfiles_8085.lst)
#       Same pattern as am9511/c/Makefile — do not use zsdcc/SDCC for 8085.
# 8080: sccz80 only → 8080/

CFILES = $(wildcard *.c)
AFILES = $(CFILES:.c=.asm)
CFLAGS += -I.

.PHONY: all z80 8085 8080 clean

all: $(addprefix z80/,$(AFILES))

z80/%.asm: %.c
	@mkdir -p z80
	zcc +z80 -clib=sdcc_ix --reserve-regs-iy --allow-unsafe-read --max-allocs-per-node400000 -D__MATH_MATH32 -SO3 $(CFLAGS) -a $^ -o $@

# 8085 higher functions: sccz80 only (zsdcc is Z80-only)
CFILES8085 = $(wildcard *.c)
AFILES8085 = $(CFILES8085:.c=.asm)

8085: $(addprefix 8085/,$(AFILES8085))

8085/%.asm: %.c
	@mkdir -p 8085
	zcc +test -clib=8085 -compiler=sccz80 -fp-mode=ieee -D__MATH_MATH32 \
	    -O2 --opt-code-speed=all -I. $(CFLAGS) -a $^ -o $@

# 8080 higher functions: sccz80 only (zsdcc is Z80-only)
CFILES8080 = $(wildcard *.c)
AFILES8080 = $(CFILES8080:.c=.asm)

8080: $(addprefix 8080/,$(AFILES8080))

8080/%.asm: %.c
	@mkdir -p 8080
	zcc +test -clib=8080 -compiler=sccz80 -fp-mode=ieee -D__MATH_MATH32 \
	    -O2 --opt-code-speed=all -I. $(CFLAGS) -a $^ -o $@

clean:
	$(RM) z80/*.asm z80/*.err zcc_opt.def
	$(RM) $(addprefix 8085/,$(AFILES8085)) 8085/*.err
	$(RM) $(addprefix 8080/,$(AFILES8080)) 8080/*.err
