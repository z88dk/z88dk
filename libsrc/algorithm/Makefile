#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.3 2016-07-02 15:42:55 dom Exp $

include ../Make.config

default:
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/algorithm @alg.lst

clean:
	$(RM) *.o* *.sym *.map *~ *.err zcc_opt.def *.i 
	cd AStarSearch ; $(RM) *.o* *.sym *.map *~ *.err zcc_opt.def *.i ; cd ..

