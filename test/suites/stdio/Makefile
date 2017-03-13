include ../make.config




all:	test_scanf.bin test_sprintf.bin 


test_scanf.bin: scanf.c $(SOURCES)
	$(compile)
	$(runtest)

test_sprintf.bin: sprintf.c $(SOURCES)
	$(call compile,-lm)
	$(runtest)

test_sprintf_sdcc.bin: sprintf.c $(SOURCES)
	$(compile)
	$(runtest)


clean:
	rm -f *.bin zcc_opt.def *~
