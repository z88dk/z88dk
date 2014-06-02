#
# Makefile for OZ-7xx specific libraries - oztime
#
# $Id: Makefile,v 1.5 2014-06-02 12:29:57 stefano Exp $

include ../../Make.config

all:	
	zcc +test -DOZ -D__OZ__ $(CFLAGS) *.c

clean:
	$(RM) *.o* zcc_opt.def
