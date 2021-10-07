include ../make.config



CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED

TARGET_Z80N = test_z80n_rshift.bin test_z80n_lshift.bin
TARGET_8080 = test_8080_bitfields.bin test_8080_rshift.bin test_8080_lshift.bin test_8080_compare.bin test_8080_compare0.bin test_8080_compare_const.bin test_8080_compare_mconst.bin test_8080_mult.bin test_8080_division.bin test_8080_bitwise.bin
TARGET_8085 = test_8085_bitfields.bin test_8085_rshift.bin test_8085_lshift.bin test_8085_compare.bin test_8085_compare0.bin test_8085_compare_const.bin test_8085_compare_mconst.bin test_8085_mult.bin test_8085_division.bin test_8085_bitwise.bin
TARGET_GBZ80 = test_gbz80_rshift.bin test_gbz80_lshift.bin test_gbz80_compare.bin test_gbz80_compare0.bin test_gbz80_compare_const.bin test_gbz80_compare_mconst.bin test_gbz80_mult.bin test_gbz80_division.bin test_gbz80_bitfields.bin test_gbz80_bitwise.bin test_gbz80_uminus.bin test_gbz80_loops.bin
TARGET_RC2014 = test_rc2014_rshift_CODE.bin test_rc2014_lshift_CODE.bin test_rc2014_compare_CODE.bin test_rc2014_compare0_CODE.bin test_rc2014_compare_const_CODE.bin test_rc2014_compare_mconst_CODE.bin test_rc2014_mult_CODE.bin test_rc2014_division_CODE.bin test_rc2014_bitfields_CODE.bin test_rc2014_bitwise_CODE.bin test_rc2014_uminus_CODE.bin test_rc2014_loops_CODE.bin


CFILES = $(wildcard *.c)
TARGET_Z80 := $(foreach test,$(CFILES:.c=),test_$(test).bin)

all: $(TARGET_Z80) $(TARGET_Z80N) $(TARGET_8080) $(TARGET_8085) $(TARGET_GBZ80) $(TARGET_RC2014)



test_autoinit.bin: $(SOURCES) autoinit.c
	$(call compile, -DGENMATH -DMATH_LIBRARY="\"\\\"Genmath\\\"\"", -lm )
	$(runtest)

test_callee.bin: $(SOURCES) callee.c
	$(call compile,-lm)
	$(runtest)

test_compare.bin: $(SOURCES) compare.c
	$(call compile, -Cc--opt-code-speed=all,)
	$(runtest)


test_%.bin: $(SOURCES) %.c
	$(compile)
	$(runtest)

test_z80n_%.bin: $(SOURCES) %.c
	$(compile_z80n)
	$(runtest_z80n)

test_8080_%.bin: $(SOURCES) %.c
	$(compile_8080)
	$(runtest_8080)

test_8085_%.bin: $(SOURCES) %.c
	$(compile_8085)
	$(runtest_8085)

test_gbz80_%.bin: $(SOURCES) %.c
	$(compile_gbz80)
	$(runtest_gbz80)

test_rc2014_%_CODE.bin: $(SOURCES) %.c
	$(compile_rc2014)
	$(runtest_rc2014)

clean:
	rm -f *.bin *.map $(OBJECTS) zcc_opt.def *~ *.lis
