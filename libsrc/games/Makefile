# $Id: Makefile,v 1.37 2016-11-15 11:42:34 stefano Exp $

include	../Make.config

# At this stage we could still miss the *_clib elements
# but never mind, we are not linking the objects, yet

lmc1000:
	zcc +test $(CFLAGS) -DMC1000 bit_frequency.c
	zcc +test $(CFLAGS) -DMC1000 bit_play.c

lenterprise:
	zcc +test $(CFLAGS) -DENTERPRISE bit_frequency.c
	zcc +test $(CFLAGS) -DENTERPRISE bit_play.c

lz88:
	zcc +test $(CFLAGS) -DZ88 bit_frequency.c
	zcc +test $(CFLAGS) -DZ88 bit_play.c


lzx:
	zcc +test	$(CFLAGS) -DSPECTRUM bit_frequency.c
	zcc +test	$(CFLAGS) -DSPECTRUM bit_play.c

lticalc:
	zcc +test $(CFLAGS) -DTICALC bit_frequency.c
	zcc +test $(CFLAGS) -DTICALC bit_play.c

# I'm not sure on the OZ700 clock.. let's assume it is equal to	the TI calculators one
loz:
	zcc +test $(CFLAGS) -DTICALC bit_frequency.c
	zcc +test $(CFLAGS) -DTICALC bit_play.c

lace:
	zcc +test $(CFLAGS) -DACE bit_frequency.c
	zcc +test $(CFLAGS) -DACE bit_play.c

laquarius:
	zcc +test $(CFLAGS)	-DAQUARIUS bit_frequency.c
	zcc +test $(CFLAGS)	-DAQUARIUS bit_play.c

lmsx:
	zcc +test $(CFLAGS) -DMSX bit_frequency.c
	zcc +test $(CFLAGS) -DMSX bit_play.c

ltrs80:
	zcc +test $(CFLAGS) -DTRS80 bit_frequency.c
	zcc +test $(CFLAGS) -DTRS80 bit_play.c

lvg5k:
	zcc +test	$(CFLAGS) -DVZ bit_frequency.c
	zcc +test	$(CFLAGS) -DVZ bit_play.c

lz9001:
	zcc +test	$(CFLAGS) -DZ9001 bit_frequency.c
	zcc +test	$(CFLAGS) -DZ9001 bit_play.c

# This piezo speaker has to be accessed	in its own way
lvz:
	zcc +test	$(CFLAGS) -DVZ bit_frequency.c
	zcc +test	$(CFLAGS) -DVZ bit_play.c

# As for VZ..
lgal:
	zcc +test $(CFLAGS) -DGAL bit_frequency.c
	zcc +test $(CFLAGS) -DGAL bit_play.c

lp2000:
	zcc +test $(CFLAGS) -DP2000 bit_frequency.c
	zcc +test $(CFLAGS) -DP2000 bit_play.c

# Access to SID (single bit resolution) with a full word address
lc128:
	zcc +test $(CFLAGS) -DC128 bit_frequency.c
	zcc +test $(CFLAGS) -DC128 bit_play.c

lbee:
	zcc +test $(CFLAGS) -DBEE bit_frequency.c
	zcc +test $(CFLAGS) -DBEE bit_play.c

laussie:
	zcc +test $(CFLAGS) -DAUSSIEBYTE bit_frequency.c
	zcc +test $(CFLAGS) -DAUSSIEBYTE bit_play.c

# --IXIY trick, interrupts sometimes disabled and few customizations
# dependencies are respected already in the main makefile
lzx81:
	zcc +zx81 $(CFLAGS) -DZX81 bit_frequency.c
	zcc +zx81 $(CFLAGS) -DZX81 bit_play.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o*
	$(RM) ace/*.o bee/*.o c128/*.o cpc/*.o aquarius/*.o msx/*.o 
	$(RM) sam/*.o spectrum/*.o trs80/*.o vg5k/*.o vz/*.o z88/*.o
	$(RM) gal/*.o ticalc/*.o enterprise/*.o mtx/*.o bee/*.o aussie/*.o
	$(RM) osca/*.o zx81snd/*.o mc1000/*.o pc6001/*.o p2000/*.o z9001/*.o
	$(RM) pacman/*.o

