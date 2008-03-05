# $Id: Makefile,v 1.11 2008-03-05 20:35:46 dom Exp $

include ../Make.config

lz88:
	zcc +z88 $(CFLAGS) -DZ88 bit_frequency.c
	zcc +z88 $(CFLAGS) -DZ88 bit_play.c

lzx:
	zcc +zx $(CFLAGS) -DSPECTRUM bit_frequency.c
	zcc +zx $(CFLAGS) -DSPECTRUM bit_play.c

lticalc:
	zcc +ti82 $(CFLAGS) -DTICALC bit_frequency.c
	zcc +ti82 $(CFLAGS) -DTICALC bit_play.c

# I'm not sure on the OZ700 clock.. let's assume it is equal to the TI calculators one
loz:
	zcc +ozansi $(CFLAGS) -DTICALC bit_frequency.c
	zcc +ozansi $(CFLAGS) -DTICALC bit_play.c

lace:
	zcc +aceansi $(CFLAGS) -DACE bit_frequency.c
	zcc +aceansi $(CFLAGS) -DACE bit_play.c

laquarius:
	zcc +aquarius $(CFLAGS) -DAQUARIUS bit_frequency.c
	zcc +aquarius $(CFLAGS) -DAQUARIUS bit_play.c

lmsx:
	zcc +msx $(CFLAGS) -DMSX bit_frequency.c
	zcc +msx $(CFLAGS) -DMSX bit_play.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o*
	$(RM) ace/*.o aquarius/*.o msx/*.o sam/*.o spectrum/*.o z88/*.o
