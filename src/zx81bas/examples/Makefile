#------------------------------------------------------------------------------
# decompile tape image to assembly
#------------------------------------------------------------------------------

all: SLOW.asm

SLOW.asm: SLOW.P decompile_p.pl Makefile
	perl decompile_p.pl SLOW.P

all: FAST.asm

FAST.asm: FAST.P decompile_p.pl Makefile
	perl decompile_p.pl FAST.P

all: HELLO.asm

HELLO.asm: HELLO.P decompile_p.pl Makefile
	perl decompile_p.pl HELLO.P

#------------------------------------------------------------------------------
# build tape image from mixed BASIC-assembly source
#------------------------------------------------------------------------------

all: test.p

test.p: test.bas make_p.pl Makefile
	perl make_p.pl test.bas

clean::
	$(RM) test.asm

#------------------------------------------------------------------------------
# clean common generated files
#------------------------------------------------------------------------------
clean::
	$(RM) *.dump *.o *.lis *.map *.bin *.sym *.b81
