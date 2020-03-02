include ../make.config



CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED

TARGET_ZXN = test_zxn_rshift.bin test_zxn_lshift.bin
TARGET_8080 = test_8080_bitfields.bin test_8080_rshift.bin test_8080_lshift.bin test_8080_compare.bin test_8080_compare0.bin test_8080_compare_const.bin test_8080_compare_mconst.bin test_8080_mult.bin test_8080_division.bin test_8080_bitwise.bin
TARGET_GBZ80 = test_gbz80_rshift.bin test_gbz80_lshift.bin test_gbz80_compare.bin test_gbz80_compare0.bin test_gbz80_compare_const.bin test_gbz80_compare_mconst.bin test_gbz80_mult.bin test_gbz80_division.bin test_gbz80_bitfields.bin test_gbz80_bitwise.bin test_gbz80_uminus.bin test_gbz80_loops.bin


all: test_bitfields.bin test_bitwise.bin test_uminus.bin test_loops.bin test_mult.bin test_callee.bin test_lshift.bin test_autoinit.bin test_sizeof.bin test_rshift.bin test_division.bin test_offsetof.bin test_compare0.bin test_compare_const.bin test_compare_mconst.bin test_compare.bin $(TARGET_ZXN) $(TARGET_8080) $(TARGET_GBZ80)




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

test_zxn_%.bin: $(SOURCES) %.c
	$(compile_zxn)
	$(runtest_zxn)

test_8080_%.bin: $(SOURCES) %.c
	$(compile_8080)
	$(runtest_8080)

test_gbz80_%.bin: $(SOURCES) %.c
	$(compile_gbz80)
	$(runtest_gbz80)

clean:
	rm -f *.bin *.map $(OBJECTS) zcc_opt.def *~
