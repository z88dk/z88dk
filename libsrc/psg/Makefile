#
# Build the PSG lib componente
#
# $Id: Makefile,v 1.11 2016-07-14 13:30:11 pauloscustodio Exp  /  Stefano, 03/2017 $
#

include ../Make.config


AFILES = \
	psg_channels.c \
	psg_envelope.c \
	psg_noise.c \
	psg_noise_channels.c \
	psg_tone.c \
	psg_tone_channels.c \
	psg_volume.c \

AOBJECTS = $(AFILES:.c=.o)

.PHONY:	dirs

all:    dirs $(addprefix obj/z80/, $(AOBJECTS)) $(addprefix obj/ixiy/, $(AOBJECTS)) 



dirs:
	@mkdir -p obj/z80 obj/ixiy 

clean:
	$(RM) -fr obj
	$(RM) -f */*.o
	$(RM) zcc_opt.def
