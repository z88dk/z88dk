#
# Makefile for S-OS
#
# $Id: Makefile,v 1.1 2013-12-05 09:34:00 stefano Exp $

include ../Make.config


all:
	cd tape ; $(MAKE) clean ; cd ..
	cd tape ; $(MAKE) ; cd ..

clean:
	$(RM) *.o* zcc_opt.def
	cd tape ; $(MAKE) clean ; cd ..
