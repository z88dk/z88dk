#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.1 2002-01-27 21:28:48 dom Exp $



z88_fcntl: close.o open.o open_z88.o read.o write.o \
	bdos.o getfcb.o parsefcb.o _putoffset.o setfcb.o \
	readbyte.o writebyte.o creat.o remove.o

.c.o:
	zcc -vn -make-lib $*.c


clean:
	rm -f  *.sym *.map zcc_opt.def *.o* *~
