include ../make.config



SOURCES += $(wildcard *.c) 
OBJECTS := $(SOURCES:.c=.o)
CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED


all:	test.bin 



test.bin: $(SOURCES)
	$(compile)
	$(runtest)



clean:
	rm -f test.bin $(OBJECTS) zcc_opt.def *~
