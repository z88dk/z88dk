# $Id: Makefile,v 1.8 2007-12-03 16:05:19 stefano Exp $

include ../Make.config

lzx:
	zcc +zx $(CFLAGS) bit_frequency.c
	zcc +zx $(CFLAGS) bit_play.c

lz88:
	zcc +z88 $(CFLAGS) bit_frequency.c
	zcc +z88 $(CFLAGS) bit_play.c

lace:
	zcc +aceansi $(CFLAGS) bit_frequency.c
	zcc +aceansi $(CFLAGS) bit_play.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o*
	$(RM) ace/*.o aquarius/*.o msx/*.o sam/*.o spectrum/*.o z88/*.o
