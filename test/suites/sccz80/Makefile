include ../make.config



CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED


all:	test_mult.bin test_callee.bin test_lshift.bin test_autoinit.bin



test_callee.bin: $(SOURCES) callee.c
	$(call compile,-lm)
	$(runtest)

test_mult.bin: $(SOURCES) mult.c
	$(compile)
	$(runtest)

test_lshift.bin: $(SOURCES) lshift.c
	$(compile)
	$(runtest)

test_autoinit.bin: $(SOURCES) autoinit.c
	$(call compile, -DGENMATH -DMATH_LIBRARY="\"\\\"Genmath\\\"\"", -lm)
	$(runtest)



clean:
	rm -f *.bin $(OBJECTS) zcc_opt.def *~
