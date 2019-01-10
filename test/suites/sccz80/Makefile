include ../make.config



CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED


all:	test_mult.bin test_callee.bin test_lshift.bin test_autoinit.bin test_sizeof.bin test_rshift.bin test_division.bin test_offsetof.bin test_compare0.bin test_compare_const.bin test_compare_mconst.bin test_compare.bin test_zxn_rshift.bin test_zxn_lshift.bin




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

clean:
	rm -f *.bin *.map $(OBJECTS) zcc_opt.def *~
