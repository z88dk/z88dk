#
# Makefile for S-OS
#
# $Id: Makefile,v 1.1 2013-12-05 09:34:00 stefano Exp $

include ../Make.config


all:
	$(MAKE) -C tape clean
	$(MAKE) -C tape

clean:
	$(RM) *.o* zcc_opt.def
	$(MAKE) -C tape clean
