include ../make.config




all:	test_scanf.bin test_sprintf.bin 


test_scanf.bin: scanf.c
	zcc +test -vn $(CFLAGS) $^ $(SOURCES) -o $@ -lndos
	$(MACHINE) -w 60 $@

test_sprintf.bin: sprintf.c
	zcc +test -vn $(CFLAGS) $^ $(SOURCES) -o $@ -lndos -lm
	$(MACHINE) -w 60 $@

test_sprintf_sdcc.bin: sprintf.c
	zcc +test -vn $(CFLAGS) $^ $(SOURCES) -o $@ -lndos -lm -compiler=sdcc
	$(MACHINE) -w 60 $@


clean:
	rm -f *.bin zcc_opt.def *~
