#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.2 2002-11-20 22:53:00 dom Exp $



all: clock.o time.o
    

.c.o:
	zcc -vn -make-lib $*.c

clean:
	$(RM) *.o* *.i *.sym *.map zcc_opt.def
