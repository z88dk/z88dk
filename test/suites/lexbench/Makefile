include ../make.config



SOURCES += $(wildcard *.c)
OBJECTS := $(SOURCES:.c=.o)
CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED

# kc160 excluded: lexbench builds its input with `seed % 95u`, and kc160's
# unsigned 16-bit divide/modulo helper (l_div_u) is broken — fails under BOTH
# 80cc and sccz80 (a z88dk kc160-library bug, not an 80cc codegen issue).

all:	test.bin test_r2ka.bin test_8080.bin test_8085.bin test_gbz80.bin test_z180.bin test_ez80_z80.bin test_r4k.bin



test.bin: $(SOURCES)
	$(compile)
	$(runtest)

test_r2ka.bin: $(SOURCES)
	$(compile_r2ka)
	$(runtest_r2ka)

test_r4k.bin: $(SOURCES)
	$(compile_r4k)
	$(runtest_r4k)

test_z180.bin: $(SOURCES)
	$(compile_z180)
	$(runtest_z180)

test_8080.bin: $(SOURCES)
	$(compile_8080)
	$(runtest_8080)

test_8085.bin: $(SOURCES)
	$(compile_8085)
	$(runtest_8085)

test_gbz80.bin: $(SOURCES)
	$(compile_gbz80)
	$(runtest_gbz80)

test_ez80_z80.bin: $(SOURCES)
	$(compile_ez80_z80)
	$(runtest_ez80_z80)



clean:
	rm -f test*.bin *.map $(OBJECTS) zcc_opt.def *~
