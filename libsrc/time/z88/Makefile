#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.6 2002-10-22 19:15:25 dom Exp $



all: clock.o time.o

.c.o:
	zcc +z88 -vn -make-lib $*.c

clean:
	$(RM) *.o* *.i *.sym *.map zcc_opt.def
