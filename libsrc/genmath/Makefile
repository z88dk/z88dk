#
# Wahey, a messed up makefile for building libraries!
#


all: genmath


genmath: asin.o atan2.o cosh.o sinh.o tanh.o pow.o ftoe.o ftoa.o acos.o atof.o
	z80asm -d -ns -nm -Mo -x../gen_math @genlist

.c.o:
	zcc -vn -notemp -make-lib $*.c


clean:
	rm -f *.o* *.sym *.map *.err zcc_opt.def
