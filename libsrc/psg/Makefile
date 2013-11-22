#
# Build the MSX target libraries
#
# $Id: Makefile,v 1.8 2013-11-22 07:40:38 stefano Exp $
#

include ../Make.config


AFILES = \
	psg_channels.c \
	psg_envelope.c \
	psg_noise.c \
	psg_noise_channels.c \
	psg_tone.c \
	psg_tone_channels.c \
	psg_volume.c

AOBJECTS = $(AFILES:.c=.o)


all:    $(AOBJECTS)


generic_iy:
	zcc +test $(CFLAGS) -Ca-IXIY psg_channels.c
	zcc +test $(CFLAGS) -Ca-IXIY psg_envelope.c
	zcc +test $(CFLAGS) -Ca-IXIY psg_noise.c
	zcc +test $(CFLAGS) -Ca-IXIY psg_noise_channels.c
	zcc +test $(CFLAGS) -Ca-IXIY psg_tone.c
	zcc +test $(CFLAGS) -Ca-IXIY psg_tone_channels.c
	zcc +test $(CFLAGS) -Ca-IXIY psg_volume.c


.c.o:
	zcc +test $(CFLAGS) $*.c

clean:
	$(RM) -f aquarius/*.o
	$(RM) -f cpc/*.o
	$(RM) -f mc1000/*.o
	$(RM) -f msx/*.o
	$(RM) -f pc6001/*.o
	$(RM) -f spectrum/*.o
	$(RM) -f ts2068/*.o
	$(RM) -f x1/*.o
	$(RM) -f zx81/*.o
	$(RM) *.o* *.sym *.map zcc_opt.def *.i
