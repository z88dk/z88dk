#
# Wahey, a messed up makefile for building libraries!
#


all: malloc


malloc:
	zcc -vn -make-lib calloc.c
	z80asm -d -ns -nm -Mo -x../malloc @malllist


clean:
	rm -f *.obj *.sym *.map *~ *.err *.o zcc_opt.def
