#
# Wahey, a messed up makefile for building libraries!
#


all: genmath


genmath: atan2.o cosh.o sinh.o tanh.o pow.o ftoe.o ftoa.o atof.o
# Don't compile atof cos of label clash
#	zcc -vn -make-lib atof.c
	z80asm -d -ns -nm -Mo -x../genmath @genlist

.c.o:
	zcc -vn -make-lib $*.c


clean:
	rm -f *.o* *.sym *.map *.err zcc_opt.def
