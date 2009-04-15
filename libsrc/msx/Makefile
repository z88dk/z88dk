#
# Build the MSX target libraries
#
# $Id: Makefile,v 1.4 2009-04-15 21:00:58 stefano Exp $
#

include ../Make.config


AFILES = \
	msx_blit.c \
	msx_blit_fill_vram.c \
	msx_blit_ram_vram.c \
	msx_calculate_side.c \
	msx_psg_channels.c \
	msx_psg_envelope.c \
	msx_psg_noise.c \
	msx_psg_noise_channels.c \
	msx_psg_tone.c \
	msx_psg_tone_channels.c \
	msx_psg_volume.c \
	msx_put_sprite_16.c \
	msx_put_sprite_8.c \
	msx_set_char.c \
	msx_set_char_attr.c \
	msx_set_char_color.c \
	msx_set_char_form.c \
	msx_set_mangled_mode.c \
	msx_set_sprite_16.c \
	msx_set_sprite_8.c \
	msx_set_sprite_mode.c \
	msx_vfill_v.c

AOBJECTS = $(AFILES:.c=.o)


all:    $(AOBJECTS)


.c.o:
	zcc +msx $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i
