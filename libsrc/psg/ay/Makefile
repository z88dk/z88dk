#
# Build the PSG lib components
#

include ../../Make.config

SUBDIRS = wyz vt2 arkos

CLEANDIRS = $(SUBDIRS:%=%-clean)

CFILES = \
	psg_channels.c \
	psg_envelope.c \
	psg_noise.c \
	psg_noise_channels.c \
	psg_tone.c \
	psg_tone_channels.c \
	psg_volume.c \

OBJECTS = $(CFILES:.c=.o)


all:    dirs $(SUBDIRS) $(addprefix obj/z80/, $(OBJECTS)) $(addprefix obj/ixiy/, $(OBJECTS))  $(addprefix obj/8080/, $(OBJECTS)) $(addprefix obj/z80n/,$(OBJECTS))


dirs:
	@mkdir -p obj/z80 obj/ixiy obj/8080 obj/z80n

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
	$(MAKE) -C $(@:%-clean=%) clean
