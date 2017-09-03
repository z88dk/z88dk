include ../make.config



SOURCES += $(wildcard *.c) 
OBJECTS := $(SOURCES:.c=.o)
CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED


all:	test.bin  test_rcm.bin



test.bin: $(SOURCES)
	$(call compile, -lmalloc)
	$(runtest)

test_rcm.bin: $(SOURCES)
	$(call compile_rcm, -lmalloc_rcm)
	$(runtest_rcm)

clean:
	rm -f *.bin $(OBJECTS) zcc_opt.def *~
