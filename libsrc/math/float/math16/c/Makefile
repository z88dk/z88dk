# Helper makefile to generate the checked in .asm files
#
# Z80:  sccz80 +new → z80/   (c/z80/… listed by newlibfiles_z80.lst)
# 8085: sccz80 only → 8085/  (listed by newlibfiles_8085.lst)
# 8080: sccz80 only → 8080/  (listed by newlibfiles_8080.lst)
# gbz80: sccz80 only → gbz80/ (listed by newlibfiles_gbz80.lst)
#       Hand-written cm16_sccz80_*.asm live in 8085/8080/gbz80 and are not regenerated.

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

CFILES8080 = $(wildcard *.c)
AFILES8080 = $(CFILES8080:.c=.asm)

8080: $(addprefix 8080/,$(AFILES8080))

8080/%.asm: %.c
	$(Q)mkdir -p 8080
	zcc +test -clib=8080 -compiler=sccz80 -D__MATH_MATH16 \
	    -O2 --opt-code-speed=all -I. $(CFLAGS) -a $^ -o $@

CFILESGBZ80 = $(wildcard *.c)
AFILESGBZ80 = $(CFILESGBZ80:.c=.asm)

gbz80: $(addprefix gbz80/,$(AFILESGBZ80))

gbz80/%.asm: %.c
	$(Q)mkdir -p gbz80
	zcc +test -clib=gbz80 -compiler=sccz80 -D__MATH_MATH16 \
	    -O2 --opt-code-speed=all -I. $(CFLAGS) -a $^ -o $@

clean:
	$(RM) z80/*.asm z80/*.err zcc_opt.def
	# Only C-derived higher functions; keep hand-written cm16_sccz80_*.asm
	$(RM) $(addprefix 8085/,$(AFILES8085)) 8085/*.err
	$(RM) $(addprefix 8080/,$(AFILES8080)) 8080/*.err
	$(RM) $(addprefix gbz80/,$(AFILESGBZ80)) gbz80/*.err
