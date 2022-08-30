
all: ansitest.bas cube.bas cubez88.bas dstar.bas gfx.bas cube.63 cubeflt16.63 wc.63 useless.63 rpn.63 farmalloc.63 dstar.63

info:
	@echo Building examples..

ansitest.bas: ansitest.c
	zcc +z88 -clib=ansi ansitest.c -o ansitest.bas

cube.bas: cube.c
	zcc +z88 cube.c -o cube.bas -lm

cubez88.bas: cube.c
	zcc +z88 cube.c -o cubez88.bas -lmz

%.bas: %.c
	zcc +z88 $^ -o $@

farmalloc.63: farmalloc.c
	zcc +z88 $^ -subtype=app -create-app -o $(@:.63=.bin) -lfarz88

cubeflt16.63: cube.c
	zcc +z88 $^ --math16 -subtype=app -create-app -o $(@:.63=.bin)

%.63: %.c
	zcc +z88 $^ -subtype=app -create-app -o $(@:.app=.bin) -lm

clean:
	$(RM) *.bas *.bin *.ap0 *.reloc *.63 *.epr
	$(RM) zcc_opt.def *.op* *.o *.i *.asm *.err *.map *.sym
	$(MAKE) -C app clean
