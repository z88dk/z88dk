#
# Wahey, a messed up makefile for building libraries!
#


all: z88math


z88math:
	z80asm -d -ns -nm -Mo -x../mz @z88list


clean:
	rm -f *.obj *.sym *.map *.err *.o
