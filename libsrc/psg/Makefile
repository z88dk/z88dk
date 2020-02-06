#
# Build the PSG lib componente
#
# $Id: Makefile,v 1.11 2016-07-14 13:30:11 pauloscustodio Exp  /  Stefano, 03/2017 $
#

include ../Make.config

SUBDIRS = wyz

CLEANDIRS = $(SUBDIRS:%=clean-%)

CFILES = \
	psg_channels.c \
	psg_envelope.c \
	psg_noise.c \
	psg_noise_channels.c \
	psg_tone.c \
	psg_tone_channels.c \
	psg_volume.c \

OBJECTS = $(CFILES:.c=.o)


all:    dirs $(SUBDIRS) $(addprefix obj/z80/, $(OBJECTS)) $(addprefix obj/ixiy/, $(OBJECTS)) 



dirs:
	@mkdir -p obj/z80 obj/ixiy 

clean: subdirs-clean
	$(RM) -fr obj
	$(RM) -f */*.o
	$(RM) zcc_opt.def

.PHONY: dirs subdirs-all $(SUBDIRS) $(SUBDIRS_CLEAN)

subdirs-all: $(SUBDIRS) 

subdirs-clean: $(CLEANDIRS)

$(SUBDIRS):
	$(MAKE) -C $@ all

$(CLEANDIRS):
	$(MAKE) -C $(@:clean-%=%) clean
