#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.18 2007-10-02 14:13:48 stefano Exp $

include ../Make.config

default:
	$(LIBLINKER) -x$../$(OUTPUT_DIRECTORY)/malloc @malllist

clean:
	cd strings ; $(RM) *.o* ; cd ..
	$(RM) *.o* *.sym *.map *~ *.err zcc_opt.def *.i 

