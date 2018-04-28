include ../make.config



SOURCES += $(wildcard *.c) 

CFLAGS += -DMAX_TESTS=300 -DNO_LOG_RUNNING -DNO_LOG_PASSED

all:	test.bin  test_rcm.bin


%.opt: %.c
	zcc +test -vn $(CFLAGS) $^ -o $@ -a

test.bin: $(SOURCES)
	$(compile)
	$(runtest)

test_rcm.bin: $(SOURCES)
	$(compile_rcm)
	$(runtest_rcm)

clean:
	rm -f test*.bin *.map $(OBJECTS) zcc_opt.def *~
