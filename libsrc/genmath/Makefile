#
# Wahey, a messed up makefile for building libraries!
#


all: genmath


genmath:
	zcc -vn -make-lib atan2.c
	zcc -vn -make-lib cosh.c
	zcc -vn -make-lib sinh.c
	zcc -vn -make-lib tanh.c
	zcc -vn -make-lib pow.c
	zcc -vn -make-lib ftoe.c
	zcc -vn -make-lib ftoa.c
	z80asm -d -ns -nm -Mo -x../m @genlist


clean:
	rm -f *.obj *.sym *.map *.o *.err
