include ../make.config



SOURCES += $(wildcard *.c) 
OBJECTS := $(SOURCES:.c=.o)
CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED


all:	test.bin test_r2ka.bin test_kc160.bin test_r4k.bin \
	test_8080.bin test_8085.bin test_gbz80.bin test_ez80_z80.bin


test.bin: $(SOURCES)
	$(compile)
	$(runtest)

test_r2ka.bin: $(SOURCES)
	$(compile_r2ka)
	$(runtest_r2ka)

test_kc160.bin: $(SOURCES)
	$(compile_kc160)
	$(runtest_kc160)

test_r4k.bin: $(SOURCES)
	$(compile_r4k)
	$(runtest_r4k)

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
	rm -f *.bin *.map $(OBJECTS) zcc_opt.def *~
