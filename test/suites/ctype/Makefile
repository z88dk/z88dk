include ../make.config



#SOURCES += $(wildcard test_*.c) main.c

SOURCE1 = $(SOURCES) test_isalpha.c test_isupper.c  main.c
CFLAGS += -DMAX_TESTS=300 -DNO_LOG_RUNNING -DNO_LOG_PASSED

all:	run



test1.bin: $(SOURCES) test_isxdigit.c test_isupper.c main.c
	zcc +test -vn $(CFLAGS) -DHAVE_ISXDIGIT -DHAVE_ISUPPER $^ -o $@ -lndos

test2.bin: $(SOURCES) test_isspace.c test_ispunct.c main.c
	zcc +test -vn $(CFLAGS) -DHAVE_ISSPACE -DHAVE_ISPUNCT $^ -o $@ -lndos

test3.bin: $(SOURCES) test_isprint.c test_islower.c main.c
	zcc +test -vn $(CFLAGS) -DHAVE_ISPRINT -DHAVE_ISLOWER $^ -o $@ -lndos

test4.bin: $(SOURCES) test_isgraph.c test_isdigit.c main.c
	zcc +test -vn $(CFLAGS) -DHAVE_ISGRAPH -DHAVE_ISDIGIT $^ -o $@ -lndos

test5.bin: $(SOURCES) test_iscntrl.c test_isascii.c main.c
	zcc +test -vn $(CFLAGS) -DHAVE_ISCNTRL -DHAVE_ISASCII $^ -o $@ -lndos

test6.bin: $(SOURCES) test_isalpha.c test_isalnum.c main.c
	zcc +test -vn $(CFLAGS) -DHAVE_ISALPHA -DHAVE_ISALNUM $^ -o $@ -lndos

test7.bin: $(SOURCES) test_isbdigit.c test_isodigit.c main.c
	zcc +test -vn $(CFLAGS) -DHAVE_ISBDIGIT -DHAVE_ISODIGIT $^ -o $@ -lndos

run: run-test1 run-test2 run-test3 run-test4 run-test5 run-test6 run-test7

run-test1: test1.bin
	$(MACHINE) test1.bin
run-test2: test2.bin
	$(MACHINE) test2.bin
run-test3: test3.bin
	$(MACHINE) test3.bin
run-test4: test4.bin
	$(MACHINE) test4.bin
run-test5: test5.bin
	$(MACHINE) test5.bin
run-test6: test6.bin
	$(MACHINE) test6.bin
run-test7: test7.bin
	$(MACHINE) test7.bin


clean:
	rm -f test*.bin $(OBJECTS) zcc_opt.def *~
