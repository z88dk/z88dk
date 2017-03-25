include ../make.config



CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED


all:	test_mult.bin test_callee.bin test_lshift.bin



test_callee.bin: $(SOURCES) callee.c
	$(call compile,-lm)
	$(runtest)

test_mult.bin: $(SOURCES) mult.c
	$(compile)
	$(runtest)

test_lshift.bin: $(SOURCES) lshift.c
	$(compile)
	$(runtest)



clean:
	rm -f *.bin $(OBJECTS) zcc_opt.def *~
