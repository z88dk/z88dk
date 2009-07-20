



SOURCES := $(wildcard *.c) ../../framework/test.c
OBJECTS := $(SOURCES:.c=.o)

# Not sure why W9 comes up
CFLAGS = -I../../framework -Wn9


all:	test.bin run



test.bin: $(SOURCES)
	zcc +test -vn $(CFLAGS) $(SOURCES) -o $@ -lndos

run: test.bin
	../../machine/machine test.bin


clean:
	rm -f test.bin $(OBJECTS) zcc_opt.def *~
