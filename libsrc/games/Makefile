# $Id: Makefile,v 1.1 2001-10-16 18:03:03 dom Exp $

lzx:
	zcc +zx -vn -make-lib bit_frequency.c
	zcc +zx -vn -make-lib bit_play.c

lz88:
	zcc +z88 -vn -make-lib bit_frequency.c
	zcc +z88 -vn -make-lib bit_play.c

clean:
	rm -f *.sym *.map zcc_opt.def *.o* */*.o
