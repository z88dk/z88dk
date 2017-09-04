include ../make.config



SOURCES += $(wildcard *.c) 
OBJECTS := $(SOURCES:.c=.o)
CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED


all:	test.bin test_rcm.bin



test.bin: $(SOURCES)
	$(compile)
	$(runtest)

test_rcm.bin: $(SOURCES)
	$(compile_rcm)
	$(runtest_rcm)



clean:
	rm -f test*.bin $(OBJECTS) zcc_opt.def *~
