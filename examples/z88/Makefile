
all: info ansitest cube cubez88 dstar gfx

all16: info anstst16 cube cubez88 dstar gfx

info:
	@echo Building examples..

ansitest:
	- zcc -lz88ansi_clib ansitest.c -o ansitest.bas

anstst16:
	- zcc -lz88ans~1 ansitest.c -o ansitest.bas

cube:
	- zcc -lm -lgfx cube.c -o cube.bas

cubez88:
	- zcc -lmz -lgfx cube.c -o cubez88.bas

dstar:
	- zcc -lgfx dstar.c -o dstar.bas

gfx:
	- zcc -lgfx gfx.c -o gfx.bas

clean:
	$(RM) ansitest.bas cube.bas cubez88.bas dstar.bas gfx.bas 
	$(RM) zcc_opt.def *.op* *.o *.i *.asm *.err *.map *.sym
