#
# Makefile for +3 file support
#
# $Id: Makefile,v 1.7 2008-06-29 08:25:41 aralbrec Exp $

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
