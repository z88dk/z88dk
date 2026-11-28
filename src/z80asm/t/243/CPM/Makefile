# Makefile to test linking of .rel files

# test program built with m80 and l80
all: relmain.dis relmain.out

relmain.dis: relmain.com Makefile
	z88dk-dis -o 0x100 $< > $@

relmain.out: relmain.com filter_cpm.pl test_file.pl Makefile
	cpm relmain > relmain.out1
	perl filter_cpm.pl relmain.out1 relmain.out
	rm relmain.out1
	perl test_file.pl relmain.out "HELLO !"

# test program built with z88dk
all: testcode.dis testcode.out

rz88dka.o: rz88dka.asm Makefile
	z88dk-z80asm $<

rz88dkb.o: rz88dkb.asm Makefile
	z88dk-z80asm $<

testcode.com: rz88dka.o rz88dkb.o testcode.c Makefile
	zcc +cpm -lndos -create-app testcode.c rz88dka.o rz88dkb.o

testcode.dis: testcode.com Makefile
	z88dk-dis -o 0x100 $< > $@

testcode.out: testcode.com filter_cpm.pl test_file.pl Makefile
	cpm testcode > testcode.out1
	perl filter_cpm.pl testcode.out1 testcode.out
	rm testcode.out1
	perl test_file.pl testcode.out "HELLO !"

# test program built with z88dk with rel files
all: testcode2.dis testcode2.out

testcode2.c: testcode.c
	cp $< $@

testcode2.com: reltesta.rel reltestb.rel testcode2.c Makefile
	zcc +cpm -lndos -create-app testcode2.c reltesta.rel reltestb.rel

testcode2.dis: testcode2.com Makefile
	z88dk-dis -o 0x100 $< > $@

testcode2.out: testcode2.com filter_cpm.pl test_file.pl Makefile
	cpm testcode2 > testcode2.out1
	perl filter_cpm.pl testcode2.out1 testcode2.out
	rm testcode2.out1
	perl test_file.pl testcode2.out "HELLO !"
