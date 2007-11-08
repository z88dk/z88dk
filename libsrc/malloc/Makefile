#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.19 2007-11-08 14:11:50 stefano Exp $

include ../Make.config

default:
	$(LIBLINKER) -x../$(OUTPUT_DIRECTORY)/malloc @malllist

clean:
	cd strings ; $(RM) *.o* ; cd ..
	$(RM) *.o* *.sym *.map *~ *.err zcc_opt.def *.i 

