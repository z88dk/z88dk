



SOURCES := $(wildcard *.c) ../../framework/test.c
CFLAGS = -I../../framework


all:	test.bin 


test.bin: $(SOURCES)
	zcc +test -vn $(CFLAGS) $(SOURCES) -o $@ -lndos
	../../machine/machine -w 60 test.bin


clean:
	rm -f test.bin zcc_opt.def *~
