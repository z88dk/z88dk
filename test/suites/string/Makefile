include ../make.config



SOURCES += $(wildcard *.c) 
OBJECTS := $(SOURCES:.c=.o)
CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED


all:	test.bin test_rcm.bin test_8080.bin test_8085.bin test_gbz80.bin test_rc2014_CODE.bin



test.bin: $(SOURCES)
	$(compile)
	$(runtest)

test_rcm.bin: $(SOURCES)
	$(compile_rcm)
	$(runtest_rcm)

test_8080.bin: $(SOURCES)
	$(compile_8080)
	$(runtest_8080)

test_8085.bin: $(SOURCES)
	$(compile_8085)
	$(runtest_8085)

test_gbz80.bin: $(SOURCES)
	$(compile_gbz80)
	$(runtest_gbz80)

test_rc2014_CODE.bin: $(SOURCES)
	$(compile_rc2014)
	$(runtest_rc2014)


clean:
	rm -f test*.bin *.map $(OBJECTS) zcc_opt.def *~
