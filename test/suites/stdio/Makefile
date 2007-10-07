



SOURCES := $(wildcard *.c)


all:	test.bin 


test.bin: $(SOURCES)
	zcc +test -vn $(SOURCES) -o $@ -lndos
	../../machine/machine -w 60 test.bin


clean:
	rm -f test.bin zcc_opt.def *~
