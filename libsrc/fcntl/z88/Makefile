#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.3 2001-04-30 14:40:04 dom Exp $



z88_fcntl: close.o creat.o lseek.o open.o open_z88.o nropen.o read.o write.o \
	writebyte.o readbyte.o stat.o opendor.o readdor.o closedor.o \
	writedor.o deletedor.o sondor.o brotherdor.o

.c.o:
	zcc -vn -make-lib $*.c


clean:
	rm -f  *.sym *.map zcc_opt.def *.o*
