# $Id: Makefile,v 1.5 2003-09-15 22:54:57 denniz Exp $

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
