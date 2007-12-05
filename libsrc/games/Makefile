# $Id: Makefile,v 1.9 2007-12-05 07:41:32 stefano Exp $

include ../Make.config

all:
	zcc $(CFLAGS) bit_frequency.c
	zcc $(CFLAGS) bit_play.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o*
	$(RM) ace/*.o aquarius/*.o msx/*.o sam/*.o spectrum/*.o z88/*.o
