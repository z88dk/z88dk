#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.5 2001-04-30 14:34:16 dom Exp $



all: clock.o time.o

.c.o:
	zcc +z88 -vn -make-lib $*.c

clean:
	rm -f *.o* *.i *.sym *.map zcc_opt.def
