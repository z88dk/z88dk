#
# Build the MSX target libraries
#
# $Id: Makefile,v 1.2 2013-11-18 13:44:18 stefano Exp $
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
	$(RM) *.o* *.sym *.map zcc_opt.def *.i
