include ../make.config



SOURCES += $(wildcard *.c) 


all:	test.bin 


test.bin: $(SOURCES)
	zcc +test -vn $(CFLAGS) $(SOURCES) -o $@ -lndos
	$(MACHINE) -w 60 test.bin


clean:
	rm -f test.bin zcc_opt.def *~
