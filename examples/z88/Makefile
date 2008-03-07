
all: info ansitest cube cubez88 dstar gfx

all16: info anstst16 cube cubez88 dstar gfx

info:
	@echo Building examples..

ansitest:
	- zcc +z88 -lz88ansi_clib ansitest.c -o ansitest.bas

anstst16:
	- zcc +z88 -lz88ans~1 ansitest.c -o ansitest.bas

cube:
	- zcc +z88 -lm -lgfx cube.c -o cube.bas

cubez88:
	- zcc +z88 -lmz -lgfx cube.c -o cubez88.bas

dstar:
	- zcc +z88 -lgfx dstar.c -o dstar.bas

gfx:
	- zcc +z88 -lgfx gfx.c -o gfx.bas

clean:
	$(RM) ansitest.bas cube.bas cubez88.bas dstar.bas gfx.bas 
	$(RM) zcc_opt.def *.op* *.o *.i *.asm *.err *.map *.sym
