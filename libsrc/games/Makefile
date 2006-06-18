# $Id: Makefile,v 1.6 2006-06-18 14:55:43 dom Exp $

include ../Make.config

lzx:
	zcc +zx -vn -make-lib bit_frequency.c
	zcc +zx -vn -make-lib bit_play.c

lz88:
	zcc +z88 -vn -make-lib bit_frequency.c
	zcc +z88 -vn -make-lib bit_play.c

lace:
	zcc +aceansi -vn -make-lib bit_frequency.c
	zcc +aceansi -vn -make-lib bit_play.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o*
	$(RM) ace/*.o aquarius/*.o sam/*.o spectrum/*.o z88/*.o
