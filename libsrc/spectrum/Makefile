#
# Makefile for ZX Spectrum target specific lib
#
# $Id: Makefile,v 1.8 2008-07-18 15:38:51 stefano Exp $

include ../Make.config


all:	
	cd tape ; $(MAKE) ; cd ..

clean:
	$(RM) *.o* zcc_opt.def
	cd basic ; $(RM) *.o* ; cd ..
	cd diagnostic ; $(RM) *.o* ; cd ..
	cd display ; $(RM) *.o* ; cd ..
	cd if1 ; $(RM) *.o* ; cd ..
	cd opus ; $(RM) *.o* ; cd ..
	cd tape ; $(RM) *.o* ; cd ..
	cd uspeech ; $(RM) *.o* ; cd ..
