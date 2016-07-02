
all: info ansitest.bas cube.bas cubez88.bas dstar.bas gfx.bas apps

info:
	@echo Building examples..

ansitest.bas: ansitest.c
	zcc +z88 -clib=ansi ansitest.c -o ansitest.bas

cube.bas: cube.c
	zcc +z88 -lm cube.c -o cube.bas

cubez88.bas: cube.c
	zcc +z88 cube.c -o cubez88.bas -lmz

dstar.bas: dstar.c dstar.h
	zcc +z88 dstar.c -o dstar.bas

gfx.bas: gfx.c
	zcc +z88 gfx.c -o gfx.bas

apps:
	$(MAKE) -C app

.PHONY: apps

clean:
	$(RM) ansitest.bas cube.bas cubez88.bas dstar.bas gfx.bas  *.reloc
	$(RM) zcc_opt.def *.op* *.o *.i *.asm *.err *.map *.sym
	$(MAKE) -C app clean
