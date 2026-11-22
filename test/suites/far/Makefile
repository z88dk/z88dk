include ../make.config



SOURCES += $(wildcard *.c) 
OBJECTS := $(SOURCES:.c=.o)
CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED


all:	test.bin 



test.bin: $(SOURCES)
	$(call compile,-lm)
	$(runtest)

clean:
	rm -f test*.bin *.map $(OBJECTS) zcc_opt.def *~
