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
# assemble zx81 rom
#------------------------------------------------------------------------------

all: zx81.bin

zx81.bin: zx81.asm Makefile
	z88dk-z80asm -b -l $<

#------------------------------------------------------------------------------
# make consts.inc
#------------------------------------------------------------------------------

all: consts.inc

consts.inc: consts.def Makefile
	z88dk-ucpp "-DX(name,value)=name equ value" -o $@ $<
	dos2unix $@

#------------------------------------------------------------------------------
# utility routines
#------------------------------------------------------------------------------

LIB = 			zx81bas.lib

LIB_SRCS = 		lower_ramtop.asm \
				screen_addr.asm \
				plot.asm \
				unplot.asm \
				get_pixel.asm \
				invert_pixel.asm
				
TEST_SRCS = 	test_lower_ramtop.bas \
				test_screen_addr.bas \
				test_plot.bas \
				test_unplot.bas \
				test_get_pixel.bas \
				test_invert_pixel.bas

all: $(LIB)

$(LIB): $(LIB_SRCS) consts.inc Makefile
	z88dk-z80asm -l -x$(LIB) $(LIB_SRCS)

all: $(TEST_SRCS:.bas=.p)

test_%.p: test_%.bas $(LIB)
	perl make_p.pl -l$(LIB) $<

#------------------------------------------------------------------------------
# clean generated files
#------------------------------------------------------------------------------

clean::
	$(RM) *.dump *.o *.lib *.lis *.map *.bin *.sym *.b81 *.bak
	$(RM) $(TEST_SRCS:.bas=.asm) $(TEST_SRCS:.bas=.p)
