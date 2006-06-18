#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.4 2006-06-18 17:59:39 dom Exp $


include ../../Make.config

all: 	DsDisplayEllipse.o

.c.o:  
	zcc +rex $(CFLAGS) $*.c


clean:
	$(RM) *.sym *.map zcc_opt.def *.o*
