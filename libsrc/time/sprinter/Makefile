#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.3 2002-12-08 15:24:44 dom Exp $



all: clock.o time.o
    

.c.o:
	zcc -vn -make-lib $*.c

clean:
	$(RM) *.o* *.i *.sym *.map zcc_opt.def *.asm
