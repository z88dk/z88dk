# $Id: Makefile,v 1.2 2001-10-22 09:33:55 stefano Exp $

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
	rm -f *.sym *.map zcc_opt.def *.o* */*.o
