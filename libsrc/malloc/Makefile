#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.20 2016-07-02 15:42:55 dom Exp $

include ../Make.config

default: $(wildcard *.asm) malllist
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/malloc @malllist

clean:
	cd strings ; $(RM) *.o* ; cd ..
	$(RM) *.o* *.sym *.map *~ *.err zcc_opt.def *.i 

