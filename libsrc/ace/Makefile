#
# Makefile for Jupiter ACE target specific lib
#
# $Id: Makefile,v 1.1 2010-05-31 08:29:06 stefano Exp $

include ../Make.config


all:	
	cd tape ; $(MAKE) ; cd ..

clean:
	$(RM) *.o* zcc_opt.def
	cd tape ; $(MAKE) clean ; cd ..
