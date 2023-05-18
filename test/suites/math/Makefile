include ../make.config



FPSOURCES = $(SOURCES) math.c
FPOBJECTS := $(FPSOURCES:.c=.o)
FIXSOURCES = $(SOURCES) fixmath.c
FIXOBJECTS := $(FIXSOURCES:.c=.o)
CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED 


all: test_genmath.bin test_math48.bin test_math32.bin test_math16.bin test_daimath32.bin \
	test_math48_rc2014_CODE.bin test_9511_rc2014_CODE.bin test_cpcmath.bin \
	test_mbf32.bin test_mbf32_8080.bin test_mbf32_8085.bin test_mbf32_gbz80.bin \
	test_9511.bin test_9511_8085.bin test_bbcmath.bin test_fixmath.bin

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
	$(call compile_8080, -DMBF32 --math-mbf32_8080 -DMATH_LIBRARY="\"\\\"MBF32\\\"\"")
	$(runtest_8080)

test_mbf32_8085.bin: $(FPSOURCES)
	$(call compile_8085, -DMBF32 --math-mbf32_8085 -DMATH_LIBRARY="\"\\\"MBF32\\\"\"")
	$(runtest_8085)

test_9511.bin: $(FPSOURCES)
	$(call compile, -DAM9511 --math-am9511 -DMATH_LIBRARY="\"\\\"AM9511-z80\\\"\"")
	$(runtest)

test_9511_8085.bin: $(FPSOURCES)
	$(call compile_8085, -DAM9511 --math-am9511_8085 -DMATH_LIBRARY="\"\\\"AM9511-8085\\\"\"")
	$(runtest_8085)

test_mbf32_gbz80.bin: $(FPSOURCES)
	$(call compile_gbz80, -DMBF32 --math-mbf32_gbz80 -DMATH_LIBRARY="\"\\\"MBF32\\\"\"")
	$(runtest_gbz80)

test_math48.bin: $(FPSOURCES)
	$(call compile, -DMATH48 -DMATH_LIBRARY="\"\\\"Math48\\\"\"", -lmath48)
	$(runtest)

test_math32.bin: $(FPSOURCES)
	$(call compile, -DMATH32 -D__MATH_MATH32 -fp-mode=ieee -DMATH_LIBRARY="\"\\\"Math32\\\"\"", -lmath32)
	$(runtest)

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
	$(call compile, -DMATH16 -D__MATH_MATH16 -fp-mode=ieee -DMATH_LIBRARY="\"\\\"Math16\\\"\"", -lmath16 -lmath32)
	$(runtest)

test_daimath32.bin: $(FPSOURCES)
	$(call compile, -DMATHDAI32 -D__MATH_DAI32 --math-dai32 -DMATH_LIBRARY="\"\\\"daimath32\\\"\"",)
	$(runtest)

clean:
	rm -f *.bin *.map *.lis $(FPOBJECTS) $(FIXOBJECTS) zcc_opt.def *~
