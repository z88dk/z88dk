include ../make.config




all:	test_scanf.bin test_sprintf.bin  test_scanf_rcm.bin test_sprintf_rcm.bin test_sprintf_8080.bin test_sprintf_gbz80.bin test_scanf_8080.bin


test_scanf.bin: scanf.c $(SOURCES)
	$(compile)
	$(runtest)

test_scanf_rcm.bin: scanf.c $(SOURCES)
	$(compile_rcm)
	$(runtest_rcm)

test_scanf_8080.bin: scanf.c $(SOURCES)
	$(compile_8080)
	$(runtest_8080)

test_sprintf.bin: sprintf.c $(SOURCES)
	$(call compile,-lm)
	$(runtest)

test_sprintf_8080.bin: sprintf.c $(SOURCES)
	$(call compile_8080,-lm)
	$(runtest_8080)

test_sprintf_gbz80.bin: sprintf.c $(SOURCES)
	$(call compile_gbz80,-lm)
	$(runtest_gbz80)

test_sprintf_rcm.bin: sprintf.c $(SOURCES)
	$(call compile_rcm,-lm)
	$(runtest_rcm)

test_sprintf_sdcc.bin: sprintf.c $(SOURCES)
	$(compile)
	$(runtest)


clean:
	rm -f *.bin *.map zcc_opt.def *~
