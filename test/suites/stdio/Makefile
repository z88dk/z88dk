include ../make.config




all:	test_scanf.bin test_sprintf.bin  test_scanf_r2ka.bin test_sprintf_r2ka.bin test_sprintf_8080.bin test_sprintf_gbz80.bin test_scanf_8080.bin test_sprintf_ez80_z80.bin test_scanf_ez80_z80.bin test_scanf_r4k.bin test_sprintf_r4k.bin


test_scanf.bin: scanf.c $(SOURCES)
	$(compile)
	$(runtest)

test_scanf_r2ka.bin: scanf.c $(SOURCES)
	$(compile_r2ka)
	$(runtest_r2ka)

test_scanf_r4k.bin: scanf.c $(SOURCES)
	$(compile_r4k)
	$(runtest_r4k)

test_scanf_8080.bin: scanf.c $(SOURCES)
	$(compile_8080)
	$(runtest_8080)

test_scanf_ez80_z80.bin: scanf.c $(SOURCES)
	$(compile_ez80_z80)
	$(runtest_ez80_z80)

test_sprintf.bin: sprintf.c $(SOURCES)
	$(call compile,-lm)
	$(runtest)

test_sprintf_8080.bin: sprintf.c $(SOURCES)
	$(call compile_8080)
	$(runtest_8080)

test_sprintf_gbz80.bin: sprintf.c $(SOURCES)
	$(call compile_gbz80)
	$(runtest_gbz80)

test_sprintf_ez80_z80.bin: sprintf.c $(SOURCES)
	$(call compile_ez80_z80,-lm)
	$(runtest_ez80_z80)

test_sprintf_r2ka.bin: sprintf.c $(SOURCES)
	$(call compile_r2ka)
	$(runtest_r2ka)

test_sprintf_r4k.bin: sprintf.c $(SOURCES)
	$(call compile_r4k)
	$(runtest_r4k)


test_sprintf_sdcc.bin: sprintf.c $(SOURCES)
	$(compile)
	$(runtest)


clean:
	rm -f *.bin *.map zcc_opt.def *~
