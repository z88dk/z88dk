# $Id: Makefile,v 1.3 2002-04-22 08:25:23 dom Exp $

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
	rm -f *.sym *.map zcc_opt.def *.o*
	rm -f ace/*.o aquarius/*.o spectrum/*.o z88/*.o
