#
# Wahey, a messed up makefile for building libraries!
#


all: z88math


z88math:
	z80asm -d -ns -nm -Mo -x../z88_math @z88list


clean:
	$(RM) *.o* *.sym *.map *.err 
