include ../make.config

SOURCES += $(wildcard *.c)
OBJECTS := $(SOURCES:.c=.o)
CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED -lmath48 -lmath16

all:	test.bin

test.bin: $(SOURCES)
	$(compile)
	$(runtest)

clean::
	rm -f *.bin *.map *.asm *.o ../../framework/*.o
