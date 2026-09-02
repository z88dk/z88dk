# Helper makefile to generate the checked in .asm files
#
# Z80:  sccz80 +new → z80/   (c/z80/… listed by newlibfiles_z80.lst)
# 8085: sccz80 only → 8085/  (listed by newlibfiles_8085.lst)
#       Hand-written cm16_sccz80_*.asm live in 8085/ and are not regenerated here.

CFILES = $(wildcard *.c)
AFILES = $(CFILES:.c=.asm)
CFLAGS += -Cc-D__MATH_MATH16 -D__MATH_MATH16 -I.

all: $(addprefix z80/,$(AFILES))

z80/%.asm: %.c
	$(Q)mkdir -p z80
	zcc +z80 -clib=new -O2 --opt-code-speed=all $(CFLAGS) -a $^ -o $@

# 8085 higher functions: sccz80 only
CFILES8085 = $(wildcard *.c)
AFILES8085 = $(CFILES8085:.c=.asm)

8085: $(addprefix 8085/,$(AFILES8085))

8085/%.asm: %.c
	$(Q)mkdir -p 8085
	zcc +test -clib=8085 -compiler=sccz80 -D__MATH_MATH16 \
	    -O2 --opt-code-speed=all -I. $(CFLAGS) -a $^ -o $@

clean:
	$(RM) z80/*.asm z80/*.err zcc_opt.def
	# Only C-derived higher functions; keep hand-written cm16_sccz80_*.asm
	$(RM) $(addprefix 8085/,$(AFILES8085)) 8085/*.err
