include ../make.config



SOURCES += $(wildcard *.c) 
OBJECTS := $(SOURCES:.c=.o)
CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED


all:	test_genmath.bin  test_math48.bin



test_genmath.bin: $(SOURCES)
	zcc +test -vn -DMATH_LIBRARY="\"\\\"Genmath\\\"\"" $(CFLAGS) $(SOURCES) -o $@ -lndos -lm
	$(MACHINE) $@

test_math48.bin: $(SOURCES)
	zcc +test -vn -DMATH_LIBRARY="\"\\\"Math48\\\"\"" $(CFLAGS) $(SOURCES) -o $@ -lndos -lmath48
	$(MACHINE) $@


clean:
	rm -f *.bin $(OBJECTS) zcc_opt.def *~
