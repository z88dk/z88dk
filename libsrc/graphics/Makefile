#
# Wahey, a messed up makefile for building libraries!
#



all: clean gfx clean gfxapp


gfx:
	z80asm -d -ns -nm -Mo -x../gfx -DFORz88 @gfxlist

gfxapp:
	z80asm -d -ns -nm -Mo -x../gfxapp -DAPPZ88 -DFORz88 @gfxlist

gen:
	@echo 'All in asm'

clean:
	rm -f *.o *.sym *.map */*.o
