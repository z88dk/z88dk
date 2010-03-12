#
# Makefile for ZX Spectrum target specific lib
#
# $Id: Makefile,v 1.10 2010-03-12 15:21:13 stefano Exp $

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
	cd tape ; $(MAKE) clean ; cd ..
	cd uspeech ; $(RM) *.o* ; cd ..
	cd zxmmc ; $(RM) *.o* ; cd ..
