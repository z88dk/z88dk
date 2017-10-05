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

SIDFILES = \
	c128/psg_init.c \
	c128/psg_channels.c \
	c128/psg_envelope.c \
	c128/psg_noise.c \
	c128/psg_tone.c \
	c128/psg_volume.c

AOBJECTS = $(AFILES:.c=.o)
SIDOBJECTS = $(SIDFILES:.c=.o)

.PHONY:	dirs

all:    dirs $(addprefix obj/z80/, $(AOBJECTS)) $(addprefix obj/ixiy/, $(AOBJECTS)) $(addprefix obj/, $(SIDOBJECTS))


obj/c128/%.o: c128/%.c
	zcc +c128 -mz80 $(CFLAGS) -o $@  $^


dirs:
	@mkdir -p obj/z80 obj/ixiy obj/c128

clean:
	$(RM) -f aquarius/*.o
	$(RM) -f c128/*.o
	$(RM) -f cpc/*.o
	$(RM) -f mc1000/*.o
	$(RM) -f msx/*.o
	$(RM) -f pc6001/*.o
	$(RM) -f spectrum/*.o
	$(RM) -f ts2068/*.o
	$(RM) -f tiki100/*.o
	$(RM) -f trs80/*.o
	$(RM) -f x1/*.o
	$(RM) -f zx81/*.o
	$(RM) -fr obj
