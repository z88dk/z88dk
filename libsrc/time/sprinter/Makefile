#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.1 2002-11-20 21:15:22 dom Exp $



all: clock.o 

.c.o:
	zcc -vn -make-lib $*.c

clean:
	$(RM) *.o* *.i *.sym *.map zcc_opt.def
