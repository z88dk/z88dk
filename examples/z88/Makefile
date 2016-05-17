
all: info ansitest cube cubez88 dstar gfx

info:
	@echo Building examples..

ansitest:
	- zcc +z88 -clib=ansi ansitest.c -o ansitest.bas

cube:
	- zcc +z88 -lm cube.c -o cube.bas

cubez88:
	- zcc +z88 cube.c -o cubez88.bas -lmz

dstar:
	- zcc +z88 dstar.c -o dstar.bas

gfx:
	- zcc +z88 gfx.c -o gfx.bas

clean:
	$(RM) ansitest.bas cube.bas cubez88.bas dstar.bas gfx.bas 
	$(RM) zcc_opt.def *.op* *.o *.i *.asm *.err *.map *.sym
