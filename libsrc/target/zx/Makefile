#
# Makefile for ZX Spectrum target specific lib
#
# $Id: Makefile,v 1.13 2016-10-26 13:03:31 stefano Exp $

include ../../Make.config


all:
	$(RM) -f basic/*.o*
	$(MAKE) -C fzx
	$(MAKE) -C tape clean
	$(MAKE) -C tape 

clean:
	$(MAKE) -C fzx clean
	$(MAKE) -C tape clean
	$(RM) *.o* zcc_opt.def
	$(RM) */*.o
