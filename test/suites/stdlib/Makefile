include ../make.config



SOURCES += $(wildcard *.c) 

CFLAGS += -DMAX_TESTS=300 -DNO_LOG_RUNNING -DNO_LOG_PASSED

all:	test.bin  test_rcm.bin test_8080.bin


%.opt: %.c
	zcc +test -vn $(CFLAGS) $^ -o $@ -a

test.bin: $(SOURCES)
	$(compile)
	$(runtest)

test_rcm.bin: $(SOURCES)
	$(compile_rcm)
	$(runtest_rcm)

test_8080.bin: $(SOURCES)
	$(compile_8080)
	$(runtest_8080)

clean:
	rm -f test*.bin *.map $(OBJECTS) zcc_opt.def *~
