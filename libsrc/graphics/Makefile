#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.2 2001-04-18 13:21:37 stefano Exp $


all: clean gfx clean gfxapp


gfx:
	z80asm -d -ns -nm -Mo -x../gfx -DFORz88 @gfxlist

gfxapp:
	z80asm -d -ns -nm -Mo -x../gfxapp -DAPPZ88 -DFORz88 @gfxlist

gen:
	@echo 'All in asm'

clean:
	rm -f *.o *.sym *.map */*.o
