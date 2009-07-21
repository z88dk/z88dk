include ../make.config



SOURCES += $(wildcard *.c) 

CFLAGS += -DMAX_TESTS=300 -DNO_LOG_RUNNING -DNO_LOG_PASSED

all:	test.bin run



test.bin: $(SOURCES)
	zcc +test -vn $(CFLAGS) $(SOURCES) -o $@ -lndos

run: test.bin
	$(MACHINE) test.bin


clean:
	rm -f test.bin $(OBJECTS) zcc_opt.def *~
