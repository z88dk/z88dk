include ../make.config



#SOURCES += $(wildcard test_*.c) main.c

SOURCE1 = $(SOURCES) test_isalpha.c test_isupper.c  main.c
CFLAGS += -DMAX_TESTS=300 -DNO_LOG_RUNNING -DNO_LOG_PASSED


all: test1.bin test2.bin test3.bin test4.bin test5.bin test6.bin test7.bin test1_r2ka.bin test2_r2ka.bin test3_r2ka.bin test4_r2ka.bin test5_r2ka.bin test6_r2ka.bin test7_r2ka.bin



test1.bin: $(SOURCES) test_isxdigit.c test_isupper.c main.c
	$(call compile, -DHAVE_ISXDIGIT -DHAVE_ISUPPER)
	$(runtest)

test1_r2ka.bin: $(SOURCES) test_isxdigit.c test_isupper.c main.c
	$(call compile_r2ka, -DHAVE_ISXDIGIT -DHAVE_ISUPPER)
	$(runtest_r2ka)

test2.bin: $(SOURCES) test_isspace.c test_ispunct.c main.c
	$(call compile, -DHAVE_ISSPACE -DHAVE_ISPUNCT)
	$(runtest)

test2_r2ka.bin: $(SOURCES) test_isspace.c test_ispunct.c main.c
	$(call compile_r2ka, -DHAVE_ISSPACE -DHAVE_ISPUNCT)
	$(runtest_r2ka)

test3.bin: $(SOURCES) test_isprint.c test_islower.c main.c
	$(call compile, -DHAVE_ISPRINT -DHAVE_ISLOWER)
	$(runtest)

test3_r2ka.bin: $(SOURCES) test_isprint.c test_islower.c main.c
	$(call compile_r2ka, -DHAVE_ISPRINT -DHAVE_ISLOWER)
	$(runtest_r2ka)

test4.bin: $(SOURCES) test_isgraph.c test_isdigit.c main.c
	$(call compile, -DHAVE_ISGRAPH -DHAVE_ISDIGIT)
	$(runtest)

test4_r2ka.bin: $(SOURCES) test_isgraph.c test_isdigit.c main.c
	$(call compile_r2ka, -DHAVE_ISGRAPH -DHAVE_ISDIGIT)
	$(runtest_r2ka)

test5.bin: $(SOURCES) test_iscntrl.c test_isascii.c main.c
	$(call compile, -DHAVE_ISCNTRL -DHAVE_ISASCII)
	$(runtest)

test5_r2ka.bin: $(SOURCES) test_iscntrl.c test_isascii.c main.c
	$(call compile_r2ka, -DHAVE_ISCNTRL -DHAVE_ISASCII)
	$(runtest_r2ka)

test6.bin: $(SOURCES) test_isalpha.c test_isalnum.c main.c
	$(call compile, -DHAVE_ISALPHA -DHAVE_ISALNUM)
	$(runtest)

test6_r2ka.bin: $(SOURCES) test_isalpha.c test_isalnum.c main.c
	$(call compile_r2ka, -DHAVE_ISALPHA -DHAVE_ISALNUM)
	$(runtest_r2ka)

test7.bin: $(SOURCES) test_isbdigit.c test_isodigit.c main.c
	$(call compile, -DHAVE_ISBDIGIT -DHAVE_ISODIGIT)
	$(runtest)

test7_r2ka.bin: $(SOURCES) test_isbdigit.c test_isodigit.c main.c
	$(call compile_r2ka, -DHAVE_ISBDIGIT -DHAVE_ISODIGIT)
	$(runtest_r2ka)


clean:
	rm -f test*.bin *.map $(OBJECTS) zcc_opt.def *~
