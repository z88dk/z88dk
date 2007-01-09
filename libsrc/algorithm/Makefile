#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.1 2007-01-09 10:28:22 aralbrec Exp $

include ../Make.config

default:
	$(LIBLINKER) -x../algorithm @alg.lst

clean:
	$(RM) *.o* *.sym *.map *~ *.err zcc_opt.def *.i 
	cd AStarSearch ; $(RM) *.o* *.sym *.map *~ *.err zcc_opt.def *.i ; cd ..

