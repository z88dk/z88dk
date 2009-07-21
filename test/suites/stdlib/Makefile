include ../make.config



SOURCES += $(wildcard *.c) 
OBJECTS := $(SOURCES:.c=.o)


all:	test.bin run



test.bin: $(SOURCES)
	zcc +test -vn $(CFLAGS) $(SOURCES) -o $@ -lndos

run: test.bin
	$(MACHINE) test.bin


clean:
	rm -f test.bin $(OBJECTS) zcc_opt.def *~
