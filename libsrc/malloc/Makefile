#
# Wahey, a messed up makefile for building libraries!
#


all: malloc


malloc:
	zcc -vn -make-lib calloc.c
	zcc -vn -make-lib strings/strdup.c
	z80asm -d -ns -nm -Mo -x../malloc @malllist


clean:
	rm -f *.o* *.sym *.map *~ *.err zcc_opt.def strings/*.o
