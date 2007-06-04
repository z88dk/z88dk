#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.2 2007-06-04 05:54:11 stefano Exp $

include ../Make.config

default:
	$(LIBLINKER) -x../$(OUTPUT_DIRECTORY)/algorithm @alg.lst

clean:
	$(RM) *.o* *.sym *.map *~ *.err zcc_opt.def *.i 
	cd AStarSearch ; $(RM) *.o* *.sym *.map *~ *.err zcc_opt.def *.i ; cd ..

