include ../make.config



SOURCES += $(wildcard *.c)
OBJECTS := $(SOURCES:.c=.o)
SOURCES += $(wildcard *.asm)
CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED


# memopi/memopd are IX users, so Z80-family only (no 8080/8085/gbz80)
all:	test.bin test_z180.bin test_z80n.bin test_ez80_z80.bin test_r2ka.bin test_r4k.bin test_r6k.bin test_kc160.bin

test.bin: $(SOURCES)
	$(compile)
	$(runtest)

test_z180.bin: $(SOURCES)
	$(compile_z180)
	$(runtest_z180)

test_z80n.bin: $(SOURCES)
	$(compile_z80n)
	$(runtest_z80n)

test_ez80_z80.bin: $(SOURCES)
	$(compile_ez80_z80)
	$(runtest_ez80_z80)

test_r2ka.bin: $(SOURCES)
	$(compile_r2ka)
	$(runtest_r2ka)

test_r4k.bin: $(SOURCES)
	$(compile_r4k)
	$(runtest_r4k)

test_r6k.bin: $(SOURCES)
	$(compile_r6k)
	$(runtest_r6k)

test_kc160.bin: $(SOURCES)
	$(compile_kc160)
	$(runtest_kc160)

clean:
	rm -f test*.bin *.map $(OBJECTS) zcc_opt.def *~
