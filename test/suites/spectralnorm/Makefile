include ../make.config



SOURCES += $(wildcard *.c)
OBJECTS := $(SOURCES:.c=.o)
CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED


# Floating-point bench on +test. 8080, 8085, gbz80, and vm1 link -lm.
# z80 and z80n name math32 on the recipe.
all:	test.bin test_8080.bin test_8085.bin test_vm1.bin test_gbz80.bin test_z80n.bin


test.bin: $(SOURCES)
	$(call compile,-DMATH32 -D__MATH_MATH32 -fp-mode=ieee,-lmath32)
	$(runtest)

test_z80n.bin: $(SOURCES)
	$(call compile_z80n,-DMATH32 -D__MATH_MATH32 -fp-mode=ieee,-lmath32)
	$(runtest_z80n)

test_8080.bin: $(SOURCES)
	$(call compile_8080,-lm)
	$(runtest_8080)

test_8085.bin: $(SOURCES)
	$(call compile_8085,-lm)
	$(runtest_8085)

test_vm1.bin: $(SOURCES)
	$(call compile_vm1,-lm)
	$(runtest_vm1)

test_gbz80.bin: $(SOURCES)
	$(call compile_gbz80,-lm)
	$(runtest_gbz80)


clean:
	rm -f test*.bin *.map $(OBJECTS) zcc_opt.def *~
