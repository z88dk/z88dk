#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.1 2002-01-27 16:03:43 dom Exp $


all: rs232_params.o rs232_init.o rs232_get.o rs232_put.o rs232_close.o

.c.o:  
	zcc -vn -make-lib $*.c


clean:
	rm -f *.sym *.map zcc_opt.def *.o* *~ *.err
