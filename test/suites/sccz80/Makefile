include ../make.config



CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED


all:	test_mult.bin test_callee.bin test_lshift.bin test_autoinit.bin test_sizeof.bin test_rshift.bin




test_autoinit.bin: $(SOURCES) autoinit.c
	$(call compile, -DGENMATH -DMATH_LIBRARY="\"\\\"Genmath\\\"\"", -lm)
	$(runtest)

test_callee.bin: $(SOURCES) callee.c
	$(call compile,-lm)
	$(runtest)


test_%.bin: $(SOURCES) %.c
	$(compile)
	$(runtest)

clean:
	rm -f *.bin $(OBJECTS) zcc_opt.def *~
