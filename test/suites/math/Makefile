include ../make.config



FPSOURCES = $(SOURCES) math.c
FPOBJECTS := $(FPSOURCES:.c=.o)
FIXSOURCES = $(SOURCES) fixmath.c
FIXOBJECTS := $(FIXSOURCES:.c=.o)
CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED 

# ---------------------------------------------------------------------------
# IEEE specials harness (-DMATH_SPECIALS in math.c): light Inf/NaN checks
# (div, mul/add, sqrt).  Enabled only on major z80 + 8085 products that pass:
#   math32, math32_8085, math16, math16_8085, 9511, 9511_8085
#
# Other math32 CPU products (z180/z80n/r2ka/…) share specials cores but are
# not suite-gated here — add -DMATH_SPECIALS after a green run if desired.
#
# Not enabled (no proper IEEE specials / stubs):
#   genmath, math48, mbf32*, bbcmath, cpcmath, daimath32, fix16, 9511_rc2014
#
# Folding gate: math.c uses direct forms (pinf - pinf, pinf / pinf).  Those
# are IEEE specials, not algebraic identities.  Any compiler that generalises
# integer self-identity folds onto floats will fail this harness (CI uses 80cc).
# ---------------------------------------------------------------------------

all: test_genmath.bin test_daimath32.bin test_bbcmath.bin test_math16.bin test_math16_8085.bin \
	test_math16_r6k.bin \
	test_math32.bin test_math32_z180.bin test_math32_z80n.bin \
	test_math32_r2ka.bin test_math32_r4k.bin test_math32_r6k.bin test_math32_kc160.bin \
	test_math32_8085.bin test_math32_8080.bin \
	test_math48.bin test_math48_rc2014_CODE.bin test_9511_rc2014_CODE.bin test_cpcmath.bin \
	test_mbf32.bin test_mbf32_8080.bin test_mbf32_8085.bin test_mbf32_vm1.bin test_mbf32_gbz80.bin \
	test_mbf32_r2ka.bin test_mbf32_r4k.bin test_mbf32_r6k.bin test_mbf32_ez80_z80.bin test_mbf32_kc160.bin \
	test_9511.bin test_9511_8085.bin test_fixmath.bin

test_fixmath.bin: $(FIXSOURCES)
	$(call compile, -DFIX16 -DMATH_LIBRARY="\"\\\"fix16\\\"\"", -lm)
	$(runtest)

test_genmath.bin: $(FPSOURCES)
	$(call compile, -DGENMATH -DMATH_LIBRARY="\"\\\"Genmath\\\"\"", -lm)
	$(runtest)

test_bbcmath.bin: $(FPSOURCES)
	$(call compile, -DBBCMATH --math-bbc -DMATH_LIBRARY="\"\\\"BBC\\\"\"")
	$(runtest)


test_mbf32.bin: $(FPSOURCES)
	$(call compile, -DMBF32 --math-mbf32 -DMATH_LIBRARY="\"\\\"MBF32\\\"\"")
	$(runtest)

test_cpcmath.bin: $(FPSOURCES)
	$(call compile, -DCPCMATH --math-cpc -DMATH_LIBRARY="\"\\\"CPC\\\"\"")
	$(runtest)

test_mbf32_8080.bin: $(FPSOURCES)
	$(call compile_8080, -DMBF32 --math-mbf32 -DMATH_LIBRARY="\"\\\"MBF32\\\"\"")
	$(runtest_8080)

test_mbf32_8085.bin: $(FPSOURCES)
	$(call compile_8085, -DMBF32 --math-mbf32 -DMATH_LIBRARY="\"\\\"MBF32\\\"\"")
	$(runtest_8085)

test_9511.bin: $(FPSOURCES)
	$(call compile, -DAM9511 --math-am9511 -DMATH_SPECIALS -DMATH_LIBRARY="\"\\\"AM9511-z80\\\"\"")
	$(runtest)

# vm1 gets the mbf32 row only: math32/math16 have no _vm1 product (their 8085
# cores use LDSI and RDEL, which the KR580VM1 spends on the RS prefix and
# DSUB D), and there is no am9511_vm1 either. Same shape as the 8080 row.
test_mbf32_vm1.bin: $(FPSOURCES)
	$(call compile_vm1, -DMBF32 --math-mbf32 -DMATH_LIBRARY="\"\\\"MBF32\\\"\"")
	$(runtest_vm1)

test_9511_8085.bin: $(FPSOURCES)
	$(call compile_8085, -DAM9511 --math-am9511 -DMATH_SPECIALS -DMATH_LIBRARY="\"\\\"AM9511-8085\\\"\"")
	$(runtest_8085)

test_mbf32_gbz80.bin: $(FPSOURCES)
	$(call compile_gbz80, -DMBF32 --math-mbf32 -DMATH_LIBRARY="\"\\\"MBF32\\\"\"")
	$(runtest_gbz80)

test_mbf32_ez80_z80.bin: $(FPSOURCES)
	$(call compile_ez80_z80, -DMBF32 --math-mbf32 -DMATH_LIBRARY="\"\\\"MBF32\\\"\"")
	$(runtest_ez80_z80)

test_mbf32_r2ka.bin: $(FPSOURCES)
	$(call compile_r2ka, -DMBF32 --math-mbf32 -DMATH_LIBRARY="\"\\\"MBF32\\\"\"")
	$(runtest_r2ka)

test_mbf32_r4k.bin: $(FPSOURCES)
	$(call compile_r4k, -DMBF32 --math-mbf32 -DMATH_LIBRARY="\"\\\"MBF32\\\"\"")
	$(runtest_r4k)

test_mbf32_r6k.bin: $(FPSOURCES)
	$(call compile_r6k, -DMBF32 --math-mbf32 -DMATH_LIBRARY="\"\\\"MBF32\\\"\"")
	$(runtest_r6k)

test_mbf32_kc160.bin: $(FPSOURCES)
	$(call compile_kc160, -DMBF32 --math-mbf32 -DMATH_LIBRARY="\"\\\"MBF32\\\"\"")
	$(runtest_kc160)

test_math48.bin: $(FPSOURCES)
	$(call compile, -DMATH48 -DMATH_LIBRARY="\"\\\"Math48\\\"\"", -lmath48)
	$(runtest)

test_math32.bin: $(FPSOURCES)
	$(call compile, -DMATH32 -D__MATH_MATH32 -DMATH_SPECIALS -fp-mode=ieee -DMATH_LIBRARY="\"\\\"Math32\\\"\"", -lmath32)
	$(runtest)

test_math32_z180.bin: $(FPSOURCES)
	$(call compile_z180, -DMATH32 -D__MATH_MATH32 -fp-mode=ieee -DMATH_LIBRARY="\"\\\"Math32\\\"\"", -lmath32_z180)
	$(runtest_z180)

test_math32_z80n.bin: $(FPSOURCES)
	$(call compile_z80n, -DMATH32 -D__MATH_MATH32 -fp-mode=ieee -DMATH_LIBRARY="\"\\\"Math32\\\"\"", -lmath32_z80n)
	$(runtest_z80n)

test_math32_r2ka.bin: $(FPSOURCES)
	$(call compile_r2ka, -DMATH32 -D__MATH_MATH32 -fp-mode=ieee -DMATH_LIBRARY="\"\\\"Math32\\\"\"", -lmath32_r2ka)
	$(runtest_r2ka)

test_math32_r4k.bin: $(FPSOURCES)
	$(call compile_r4k, -DMATH32 -D__MATH_MATH32 -fp-mode=ieee -DMATH_LIBRARY="\"\\\"Math32\\\"\"", -lmath32_r4k)
	$(runtest_r4k)

test_math32_r6k.bin: $(FPSOURCES)
	$(call compile_r6k, -DMATH32 -D__MATH_MATH32 -fp-mode=ieee -DMATH_LIBRARY="\"\\\"Math32\\\"\"", -lmath32_r6k)
	$(runtest_r6k)

test_math32_kc160.bin: $(FPSOURCES)
	$(call compile_kc160, -DMATH32 -D__MATH_MATH32 -fp-mode=ieee -DMATH_LIBRARY="\"\\\"Math32\\\"\"", -lmath32_kc160)
	$(runtest_kc160)

test_math32_8085.bin: $(FPSOURCES)
	$(call compile_8085, -DMATH32 -D__MATH_MATH32 -DMATH_SPECIALS -fp-mode=ieee -DMATH_LIBRARY="\"\\\"Math32-8085\\\"\"", -lmath32_8085)
	$(runtest_8085)

test_math32_8080.bin: $(FPSOURCES)
	$(call compile_8080, -DMATH32 -D__MATH_MATH32 -DMATH_SPECIALS -fp-mode=ieee -DMATH_LIBRARY="\"\\\"Math32-8080\\\"\"", -lmath32_8080)
	$(runtest_8080)

test_math48_rc2014_CODE.bin: $(FPSOURCES)
	$(call compile_rc2014, -DMATH48 -DMATH_LIBRARY="\"\\\"Math48\\\"\"", -lm)
	$(runtest_rc2014)

test_9511_rc2014_CODE.bin: $(FPSOURCES)
	$(call compile_rc2014, -DAM9511 -D__MATH_AM9511 -fp-mode=ieee -DMATH_LIBRARY="\"\\\"AM9511\\\"\"", -lam9511)
	$(runtest_rc2014)

test_math32_rc2014_CODE.bin: $(FPSOURCES)
	$(call compile_rc2014, -DMATH32 -D__MATH_MATH32 -fp-mode=ieee -DMATH_LIBRARY="\"\\\"Math32\\\"\"", -lmath32)
	$(runtest_rc2014)

test_math16.bin: $(FPSOURCES)
	$(call compile, -DMATH16 -D__MATH_MATH16 -DMATH_SPECIALS -fp-mode=ieee -DMATH_LIBRARY="\"\\\"Math16\\\"\"", -lmath16 -lmath32)
	$(runtest)

test_math16_8085.bin: $(FPSOURCES)
	$(call compile_8085, -DMATH16 -D__MATH_MATH16 -DMATH_SPECIALS -fp-mode=ieee -DMATH_LIBRARY="\"\\\"Math16-8085\\\"\"", --math16 -lmath32_8085)
	$(runtest_8085)

test_math16_r6k.bin: $(FPSOURCES)
	$(call compile_r6k, -DMATH16 -D__MATH_MATH16 -DMATH_SPECIALS -fp-mode=ieee -DMATH_LIBRARY="\"\\\"Math16-8085\\\"\"", --math16 -lmath32_r6k)
	$(runtest_r6k)

test_daimath32.bin: $(FPSOURCES)
	$(call compile, -DMATHDAI32 -D__MATH_DAI32 --math-dai32 -DMATH_LIBRARY="\"\\\"daimath32\\\"\"",)
	$(runtest)

clean:
	rm -f *.bin *.map *.lis *.err $(FPOBJECTS) $(FIXOBJECTS) zcc_opt.def *~
	rm -f .ticks_history.txt
	rm -rf specials
