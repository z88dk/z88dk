include ../make.config



SOURCES += $(wildcard *.c)
OBJECTS := $(SOURCES:.c=.o)
CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED

# kc160 excluded: hashbench builds its keys with `seed % 20u`, and kc160's
# UNSIGNED 16-bit divide/modulo library helper (l_div_u) is broken — `%` returns
# 0, `/` returns garbage — for const AND variable divisors, so the keys (and the
# checksum) come out wrong. Confirmed identical under BOTH 80cc and sccz80 (both
# call the same l_div_u), while z80/8080/8085/z180/ez80/rabbit are all correct.
# A z88dk kc160-library bug, NOT an 80cc codegen issue. (The other new benches
# avoid 16-bit / and % so they pass on kc160.)

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
