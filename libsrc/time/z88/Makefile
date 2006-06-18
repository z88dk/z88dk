#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.7 2006-06-18 14:55:44 dom Exp $


include ../../Make.config

all: clock.o time.o

.c.o:
	zcc -vn -make-lib $*.c

clean:
	$(RM) *.o* *.i *.sym *.map zcc_opt.def
