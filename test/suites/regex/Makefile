include ../make.config



SOURCES += $(wildcard *.c) 
OBJECTS := $(SOURCES:.c=.o)
CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED


all:	test.bin 



test.bin: $(SOURCES)
	zcc +test -vn -DMATH_LIBRARY="\"\\\"Genmath\\\"\"" $(CFLAGS) $(SOURCES) -o $@ -lndos -lmalloc
	$(MACHINE) $@

clean:
	rm -f *.bin $(OBJECTS) zcc_opt.def *~
