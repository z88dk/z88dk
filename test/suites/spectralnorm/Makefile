include ../make.config



SOURCES += $(wildcard *.c)
OBJECTS := $(SOURCES:.c=.o)
CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED


# Floating-point bench: z80 uses IEEE math32 (matches sdcc's 32-bit double,
# so cross-compiler comparison is apples-to-apples); the index-register-less
# CPUs (8080/8085/gbz80 — the strategic sp-mode targets) use the 32-bit MBF
# library, mirroring the math suite.
all:	test.bin test_8080.bin test_8085.bin test_gbz80.bin test_z80n.bin


test.bin: $(SOURCES)
	$(call compile,-DMATH32 -D__MATH_MATH32 -fp-mode=ieee,-lmath32)
	$(runtest)

test_z80n.bin: $(SOURCES)
	$(call compile_z80n,-DMATH32 -D__MATH_MATH32 -fp-mode=ieee,-lmath32)
	$(runtest_z80n)

test_8080.bin: $(SOURCES)
	$(call compile_8080,--math-mbf32)
	$(runtest_8080)

test_8085.bin: $(SOURCES)
	$(call compile_8085,--math-mbf32)
	$(runtest_8085)

test_gbz80.bin: $(SOURCES)
	$(call compile_gbz80,--math-mbf32)
	$(runtest_gbz80)


clean:
	rm -f test*.bin *.map $(OBJECTS) zcc_opt.def *~
