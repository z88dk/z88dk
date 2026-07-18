include ../make.config



# qsort_newlib.c #asm-INCLUDEs the newlib sort cores (asm_quicksort etc.) as
# PUBLIC symbols; kept in its own binary (main_newlib.c) so they don't shadow
# the classic library's shared sort core in the main test binary.
SOURCES += $(filter-out qsort_newlib.c main_newlib.c,$(wildcard *.c))
NEWLIB_SOURCES = $(wildcard $(FRAMEWORK_DIR)/*.c) qsort_newlib.c main_newlib.c

CFLAGS += -DMAX_TESTS=300 -DNO_LOG_RUNNING -DNO_LOG_PASSED

ifeq ($(COMPILER),xcc)
all:	test.bin test_newlib.bin
else
all:	test.bin test_r2ka.bin test_8080.bin test_ez80_z80.bin \
	test_z180.bin test_z80n.bin test_kc160.bin \
	test_newlib.bin test_newlib_r2ka.bin test_newlib_8080.bin test_newlib_ez80_z80.bin \
	test_newlib_z180.bin test_newlib_z80n.bin test_newlib_kc160.bin
endif


%.opt: %.c
	zcc +test -vn $(CFLAGS) $^ -o $@ -a

test.bin: $(SOURCES)
	$(compile)
	$(runtest)

test_r2ka.bin: $(SOURCES)
	$(compile_r2ka)
	$(runtest_r2ka)

test_8080.bin: $(SOURCES)
	$(compile_8080)
	$(runtest_8080)

test_ez80_z80.bin: $(SOURCES)
	$(compile_ez80_z80)
	$(runtest_ez80_z80)

test_z180.bin: $(SOURCES)
	$(compile_z180)
	$(runtest_z180)

test_z80n.bin: $(SOURCES)
	$(compile_z80n)
	$(runtest_z80n)

test_kc160.bin: $(SOURCES)
	$(compile_kc160)
	$(runtest_kc160)

test_newlib_z180.bin: $(NEWLIB_SOURCES)
	$(compile_z180)
	$(runtest_z180)

test_newlib_z80n.bin: $(NEWLIB_SOURCES)
	$(compile_z80n)
	$(runtest_z80n)

test_newlib_kc160.bin: $(NEWLIB_SOURCES)
	$(compile_kc160)
	$(runtest_kc160)

test_newlib.bin: $(NEWLIB_SOURCES)
	$(compile)
	$(runtest)

test_newlib_r2ka.bin: $(NEWLIB_SOURCES)
	$(compile_r2ka)
	$(runtest_r2ka)

test_newlib_8080.bin: $(NEWLIB_SOURCES)
	$(compile_8080)
	$(runtest_8080)

test_newlib_ez80_z80.bin: $(NEWLIB_SOURCES)
	$(compile_ez80_z80)
	$(runtest_ez80_z80)

clean:
	rm -f test*.bin *.map $(OBJECTS) zcc_opt.def *~
