# $Id: Makefile,v 1.10 2007-12-06 10:19:05 stefano Exp $

include ../Make.config

lz88:
	zcc $(CFLAGS) -DZ88 bit_frequency.c
	zcc $(CFLAGS) -DZ88 bit_play.c

lzx:
	zcc $(CFLAGS) -DSPECTRUM bit_frequency.c
	zcc $(CFLAGS) -DSPECTRUM bit_play.c

lticalc:
	zcc $(CFLAGS) -DTICALC bit_frequency.c
	zcc $(CFLAGS) -DTICALC bit_play.c

# I'm not sure on the OZ700 clock.. let's assume it is equal to the TI calculators one
loz:
	zcc $(CFLAGS) -DTICALC bit_frequency.c
	zcc $(CFLAGS) -DTICALC bit_play.c

lace:
	zcc $(CFLAGS) -DACE bit_frequency.c
	zcc $(CFLAGS) -DACE bit_play.c

laquarius:
	zcc $(CFLAGS) -DAQUARIUS bit_frequency.c
	zcc $(CFLAGS) -DAQUARIUS bit_play.c

lmsx:
	zcc $(CFLAGS) -DMSX bit_frequency.c
	zcc $(CFLAGS) -DMSX bit_play.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o*
	$(RM) ace/*.o aquarius/*.o msx/*.o sam/*.o spectrum/*.o z88/*.o
